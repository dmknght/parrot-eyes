#[
Parse checksums from /var/lib/dpkg/info
]#
import os
import strutils


const
  pathDpkgInfo = "/var/lib/dpkg/info/"


proc getDebChecksums*(): seq[string] =
  for kind, path in walkDir(pathDpkgInfo):
    if kind == pcFile and splitFile(path).ext == ".md5sums":
      for line in lines(path):
        # Line format: <md5sum>  <path>
        # 2 spaces
        result.add(line.split(" ")[1])
