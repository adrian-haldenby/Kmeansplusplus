Kmeans++ in Julia
--------
Adrian Haldenby a.haldenby@gmail.com

**Overview**

A simple (read sloppy) implementation of Kmeans++ in Julia. Algorithm that intelligently chooses the initial cluster centres before running Lloyd's algorithm. Check out  https://normaldeviate.wordpress.com/2012/09/30/the-remarkable-k-means/ for more info.

This is was mostly an exercise to get me acquainted with Julia so definitely not for production.

**Usage**

Simply source kmeanspp.jl and run the algorithm with the following function call

    output = run_kmeans(data,nclust,plusplus=true)

* data is an NxP matrix of data points
* nclust is an intger that specifies the number of clusters 
* plusplus is a bool that's true if  we want to use the  ++ algorithm to initialize the cluster centers

Outputs a two item Dict of "centres" and the assigned "groups" for each of the points

test_kpp.jl contains a helper function to create some synthetic data from sampling  a user user specified series of multivariate normal distributions with

    test_data = generate_cluster_data(num_clusters,num_dims,num_entries)'

* num_clusters are the number of distributions to create
* num_dims is the number of dimensions the data will have (P)
* num_entries is the number of samples from each gaussian

Output is is an P+1xN matrix where the final row is are labels for each point