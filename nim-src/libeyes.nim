import cores / [gensum, parsedb]


proc eyesGetMD5*(file_path: string, checksum: var string): int =
  return getFileMd5(file_path, checksum)


proc eyesParseDb*(): seq[string] =
  return getDebChecksums()
