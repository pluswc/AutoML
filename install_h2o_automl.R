pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (!(pkg %in% rownames(installed.packages()))) {install.packages(pkg)}
}

install.packages("h2o", 
                 type = "source",
                 repos = c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R"))

# 설치 확인 

library(h2o)
localH2O = h2o.init()
demo(h2o.kmeans)
