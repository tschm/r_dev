# Create an environment to store private functions
.MinCircleEnv <- new.env(parent = emptyenv())

# Private helper functions stored in the environment
assign(".calculate_circle_from_three_points", function(p1, p2, p3) {
  temp <- p2[1] * p2[1] + p2[2] * p2[2]
  bc <- (p1[1] * p1[1] + p1[2] * p1[2] - temp) / 2.0
  cd <- (temp - p3[1] * p3[1] - p3[2] * p3[2]) / 2.0
  det <- (p1[1] - p2[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p2[2])

  if (abs(det) < 1e-10)
    return(NULL)

  center_x <- (bc * (p2[2] - p3[2]) - cd * (p1[2] - p2[2])) / det
  center_y <- ((p1[1] - p2[1]) * cd - (p2[1] - p3[1]) * bc) / det
  radius <- sqrt((center_x - p1[1])^2 + (center_y - p1[2])^2)

  return(list(center = c(center_x, center_y), radius = radius))
}, envir = .MinCircleEnv)

assign(".calculate_circle_from_two_points", function(p1, p2) {
  center_x <- (p1[1] + p2[1]) / 2.0
  center_y <- (p1[2] + p2[2]) / 2.0
  radius <- sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2) / 2.0

  return(list(center = c(center_x, center_y), radius = radius))
}, envir = .MinCircleEnv)

assign(".is_point_inside_circle", function(point, center, radius) {
  dist <- sqrt((point[1] - center[1])^2 + (point[2] - center[2])^2)
  return(dist <= radius + 1e-10)
}, envir = .MinCircleEnv)

assign(".welzl", function(points, boundary_points = matrix(numeric(0), ncol = 2)) {
  if (nrow(boundary_points) == 3 || nrow(points) == 0) {
    if (nrow(boundary_points) == 0)
      return(list(center = c(0, 0), radius = 0))
    if (nrow(boundary_points) == 1)
      return(list(center = boundary_points[1,], radius = 0))
    if (nrow(boundary_points) == 2)
      return(.MinCircleEnv$.calculate_circle_from_two_points(boundary_points[1,], boundary_points[2,]))
    return(.MinCircleEnv$.calculate_circle_from_three_points(boundary_points[1,], boundary_points[2,], boundary_points[3,]))
  }

  idx <- sample(nrow(points), 1)
  p <- points[idx,]
  remaining_points <- points[-idx,, drop = FALSE]

  circle <- .MinCircleEnv$.welzl(remaining_points, boundary_points)

  if (!is.null(circle) && .MinCircleEnv$.is_point_inside_circle(p, circle$center, circle$radius))
    return(circle)

  return(.MinCircleEnv$.welzl(remaining_points, rbind(boundary_points, p)))
}, envir = .MinCircleEnv)

# Public functions

#' Find the minimum enclosing circle for a set of points
#' @param points A matrix with 2 columns (x and y coordinates)
#' @return A list containing the center coordinates and radius of the minimum enclosing circle
find_minimum_enclosing_circle <- function(points) {
  if (!is.matrix(points) || ncol(points) != 2)
    stop("Input must be a matrix with 2 columns (x and y coordinates)")
  if (nrow(points) == 0)
    return(list(center = c(0, 0), radius = 0))

  points <- points[sample(nrow(points)),]

  result <- .MinCircleEnv$.welzl(points)

  return(result)
}

#' Plot the points and their minimum enclosing circle
#' @param points A matrix with 2 columns (x and y coordinates)
#' @param circle A list containing center and radius of the circle
plot_minimum_circle <- function(points, circle) {
  plot(points, asp = 1, pch = 16,
       xlim = c(circle$center[1] - circle$radius - 1, circle$center[1] + circle$radius + 1),
       ylim = c(circle$center[2] - circle$radius - 1, circle$center[2] + circle$radius + 1),
       main = "Minimum Enclosing Circle")

  theta <- seq(0, 2*pi, length.out = 200)
  circle_x <- circle$center[1] + circle$radius * cos(theta)
  circle_y <- circle$center[2] + circle$radius * sin(theta)
  lines(circle_x, circle_y, col = "red")

  points(circle$center[1], circle$center[2], col = "red", pch = 4)
}
