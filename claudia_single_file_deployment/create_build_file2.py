# -*- coding: utf-8 -*-
import sys, os

buildfile = open("buildfile_deletesrc.xml", 'r')
temp = buildfile.readlines()
buildfile.close()

# Clears buildfile_deletesrc.xml from possible earlier exceptions -----
buildfile = open("buildfile_deletesrc.xml", 'w')

for line in temp:
     if '<include name=' not in line:
        buildfile.write(line)
buildfile.close()
# ----- clearing done.

# Inserts cleared buildfile_deletesrc file and new exceptions from files_to_exclude.txt to temp list
# Only lines starting with "src" is added, because there might be some irrelevant files also
# git diff --name-only HEAD~1 > files_to_exclude.txt
exclude_file = open('files_to_exclude.txt', 'r')
exclude_set = map(lambda x: x.rstrip(), exclude_file.readlines())
exclude_set.insert(1, 'src/package.xml')
print exclude_set
# git ls-files > files_to_include.txt
include_file = open('files_to_include.txt', 'r')
buildfile = open("buildfile_deletesrc.xml", 'r')
temp = buildfile.readlines()


for line in include_file:
  if line.rstrip() not in exclude_set:
    if 'src' in line:
      line = line.rstrip()
      temp.insert(17, '        <include name="' + line + '"/>\n')

#for line in temp:
    #print(line)
buildfile.close()
# ----- new list done.

# ----- Writes new list file to buildfile_deletesrc.xml
buildfile = open("buildfile_deletesrc.xml", 'w')

for line in temp:
    #print(line)
    buildfile.write(line)
buildfile.close()
# ----- Writing done to buildfile_deletesrc.xml