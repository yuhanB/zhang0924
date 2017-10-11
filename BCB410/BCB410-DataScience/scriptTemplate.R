# <filename>.R
#
# Purpose:  <replace: template for a single function that would e.g. be
#            sourced from .utilities.R or become one of the components
#            of an R package.>
#
# Version:  <number>
# Date:     YYY MM DD
# Author:   NN (name@host.tld)
#
# Dependencies:
#           <List dependencies and preconditions>
#
# License: GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
#
# Version history:
#    <number>  Status / changes
#
# ToDo:
#    <list ...>
#
# ==============================================================================

setwd("<your/project/directory>")

# ====  PARAMETERS  ============================================================
# Define and explain all parameters. No "magic numbers" in your code below.



# ====  PACKAGES  ==============================================================
# Load all required packages.

if (!require(RUnit, quietly=TRUE)) {
    install.packages("RUnit")
    library(RUnit)
}


# ====  FUNCTIONS  =============================================================

# Define functions or source external files
source("<myUtilityFunctionsScript.R>")

<functionName> <- function(<argumentName> = <defaultValue>,
                           <argumentName> = <defaultValue>,
                           <argumentName> = <defaultValue>) {
  # Purpose:
  #     <describe ...>
  #
  # Parameters:
  #     <name>:   <type>   <description
  #
  # Details:
  #     <description, notes, see-also ...>
  #
  # Value:
  #     <type, structure etc. of the single return value. Or:
  #     NA - function is invoked for its side effect of ... <describe>. >

  # <code ...>

  return(<result>)
}



# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your script here. Write your
# code so that you can simply step through this entire file and re-create all
# intermediate results. If computations are expensive, use save()/load() at
# important steps.






# ====  TESTS  =================================================================
# Enter your function unit tests and your script integration tests here...





# [END]
