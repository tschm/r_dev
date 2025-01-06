# Example usage
# Create some random points
set.seed(42)
n_points <- 1000
points <- matrix(rnorm(2*n_points), ncol = 2)

# Find the minimum enclosing circle
result <- find_minimum_enclosing_circle(points)

# Print results
print(paste("Center:", paste(round(result$center, 3), collapse = ", ")))
print(paste("Radius:", round(result$radius, 3)))

# Plot the result
plot_minimum_circle(points, result)
