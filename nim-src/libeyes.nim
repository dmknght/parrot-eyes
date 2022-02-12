import nimpy
import cores / [gensum, parsedb]
import os
import strutils


proc eyesGetMD5*(file_path: string): string {.exportpy.} =
  return getFileMd5(file_path)


proc eyesParseDb*(): seq[string] {.exportpy.} =
  return getDebChecksums()


proc eyesCmpDb*(checksum: string, db: seq[string]): bool {.exportpy.} =
  if checksum in db:
    return true
  return false


proc eyesPathFromPID*(pid: int): string {.exportpy.} =
  #[
    Get absolute path of executed pid
    path is at /proc/<id>/exe (symlink)
    Problem: process stops to quick, can't get this
  ]#
  let
    dir = "/proc/" & intToStr(pid)# & "/exe"
  if dirExists(dir):
    return expandSymlink(dir & "/exe")
