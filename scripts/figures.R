for (f in list.files(path="scripts/figures", pattern="*.R")){
  file = paste("scripts/figures", f, sep="/")
  source(file)
}
