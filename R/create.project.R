#' Create a new project.
#'
#' This function will create all of the scaffolding for a new project.
#' It will set up all of the relevant directories and their initial
#' contents. For those who only want the minimal functionality, the
#' \code{minimal} argument can be set to \code{TRUE} to create a subset of
#' ProjectTemplate's default directories. For those who want to dump
#' all of ProjectTemplate's functionality into a directory for extensive
#' customization, the \code{dump} argument can be set to \code{TRUE}.
#'
#' @param project.name A character vector containing the name for this new
#'   project. Must be a valid directory name for your file system.
#' @param minimal A boolean value indicating whether to create a minimal
#'   project or a full project. A minimal project contains only the
#'   directories strictly necessary to use ProjectTemplate and does not
#'   provide template code for profiling, unit testing or documenting your
#'   project.
#' @param dump A boolean value indicating whether the entire functionality
#'   of ProjectTemplate should be written out to flat files in the current
#'   project.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{create.project('MyProject')}
create.project <- function(project.name = 'new-project', minimal = FALSE, dump = FALSE)
{
  tmp.dir <- paste(project.name, '_tmp', sep = '')

  if (file.exists(project.name) || file.exists(tmp.dir))
  {
    stop(paste("Cannot run create.project() from a directory containing", project.name, "or", tmp.dir))
  }

  dir.create(tmp.dir)

  if (minimal)
  {
    file.copy(system.file(file.path('defaults', 'minimal'), package = 'ProjectTemplate'),
              file.path(tmp.dir),
              recursive = TRUE)
    file.rename(file.path(tmp.dir, 'minimal'),
                project.name)
  }
  else
  {
    file.copy(system.file(file.path('defaults', 'full'), package = 'ProjectTemplate'),
              file.path(tmp.dir),
              recursive = TRUE)
    file.rename(file.path(tmp.dir, 'full'),
                project.name)
  }
  
  if (dump)
  {
    1; # Magic happens here to place all of the R files from ProjectTemplate in the current folder.

    # For time being, just copy the entire contents of defaults/* and then also copy the collated R source.
    # Seriously broken at the moment.
    e <- environment(ProjectTemplate:::load.project)
    
    pt.contents <- ls(e)
    
    for (item in pt.contents)
    {
      cat(deparse(get(item, envir = e)),
          file = file.path(project.name, paste(item, '.R', sep = '')))
    }
  }

  unlink(tmp.dir, recursive = TRUE)
}
