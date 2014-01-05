# Julia Kmeans++
# addapted from: https://normaldeviate.wordpress.com/2012/09/30/the-remarkable-k-means/
# basically same as k-means except with an intelligent way of picking the initial centers

function get_distance(p1,p2)
   # Define distance function, in this case we'll use euclidean distance
   # @p1 Px1 array of int
   # @p2 Px1 array of int
   # output: float
   dist = sqrt(sum([(p1[i]-p2[i])^2 for i = 1:size(p1,1)]))
   return dist
end

function nearest_center(point,clust_centers)
    # Function to find the nearest center given a
    # @point 1xP Array: A signle point
    # @clust MxP Array: centers where M is the number of clusters
    # output: array of [group,minimum distance]
    group = 0
    lowest_dist = 1e50
    for i = 1:size(clust_centers,1)
        loc_dist =get_distance(point,clust_centers[i,:])
        if loc_dist < lowest_dist
            lowest_dist = loc_dist;
            group = i;
        end
    end
    return([group,lowest_dist])
 end

function intialize_centers(points,centers)
    # Iteratively pick points to be clusters based on how far a given point is away
    # already selected cluster centers.
    # @points NxP Array of Float of points to be clustered
    # @clust MxP Array: centers where M is the number of clusters
    # output: MxP Array of new cluster centers
    clust_centers = copy(centers)
    numdims = size(points)
    clust_centers[1,:] = points[rand(1:numdims[1]),:]
    dists = zeros(numdims[1])
    for center = 1:(size(clust_centers,1)-1)
        point_dist = 0
        for dist_entry in 1:size(dists,1)
            dists[dist_entry] = nearest_center(points[dist_entry,:],clust_centers[center,:,:][1,:])[2]
            point_dist += dists[dist_entry]
        end
        furthest_index = wsample(1:numdims[1],dists./point_dist)
        clust_centers[center+1,:] = points[furthest_index,:]
    end
    return clust_centers;
end

function run_kmeans(points,nclust,plusplus = true)
    # Run Kmeans using Lloyd's algorithm
    # @points NxP Array of Float of points to be clustered
    # @nclusts int specifying the number of clusters
    # @plusplus bool: use plusplus method if true
    # output: dict of centers and final groups
    #create the random cluster centers
    random_points = [copy(slice(pts,i,:)) for i in rand!(1:size(points,1),[1:nclust])]
    default_centers = zeros(nclust,size(points,2))
    for i in 1:nclust
        default_centers[i,:] = random_points[i]
    end
    #initialize ++
    if plusplus
        default_centers=intialize_centers(points,default_centers)
    end
    old_groups = vec(ones(size(points,1)))
    counter = 0
    while(true)
        #find closest centers:
        groups = [nearest_center(points[point_indx,:],default_centers)[1] for point_indx in 1:size(points,1)]
        group_avs = [vec(mean(points[findin(groups,float(center)),:],1)) for center in 1:nclust]
        changed = 1-sum(groups.==old_groups)/size(points,1)
        if changed < 1e-10
            return {"centers"=>default_centers,"groups"=>groups}
        end
        old_groups = copy(groups)
        #update group centers
        for i in 1:nclust
            default_centers[i,:] = group_avs[i]
        end
        println(string("Iteration: ",counter,"\n% points that changed groups:",changed))
        counter +=1
    end
end







