# Generate some sample data using samples from a series of multivariate normal distrobutions
include("kmeanspp.jl")

importall Distributions

function generate_cluster_data(num_clusters,num_dims,num_entries)
    # @num_clusters int: number of clusters we want to build
    # @num_dims int: number of dimensions our multivariate normal will have
    # @num_samps int: number of samples from each multivariate normal distrobution
    # ouput: dict where keys= class, vals =samples
    res = []
    for clust_num=1:num_clusters
        #flot the means upward to ensure some degree of seperation
        mus = rand(num_dims).+4.*clust_num*2
        #create covariance matrix, ensure diag elements are posisitve
        Cs = rand(num_dims,num_dims)*eye(num_dims,num_dims)*3;
        n = size(Cs);
        randm = rand(num_dims,num_dims)
        #Change the diagonal elements to allow for negative covariance
        for col=1:n[1], row=1:n[2]
            if row != col
                Cs[row, col] = (randm[row, col]-1)
            end
        end
        #ensure symetrical and posative semi-definite
        Cspsd = Cs'*Cs
        #add samples and labels
        mvnorm_samps= vcat(rand(MvNormal(mus, Cspsd),num_entries),[ones(num_entries)*clust_num]');
        if clust_num ==1
            res = mvnorm_samps
        else
            res= hcat(res,mvnorm_samps)
        end
    end
    return res;
end

#generate the data
all_pts = generate_cluster_data(4,3,10000)' # 10,000 from each of the 4 3 dimensional MVnorm dists
correct_groups =all_pts[:,end] #save the correct labels
pts = all_pts[:,1:end-1] #seperate the data from the their labels
grps = run_kmeans(pts,4,true) # run kmeans with 4 centers
res = hcat(all_pts,grps["groups"])
writecsv("output.csv", res) #write output to
