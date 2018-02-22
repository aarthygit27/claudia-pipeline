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
exclude_set = []
with open("files_to_exclude.txt", "r") as exclude_file:
    for line in exclude_file:
        line = line.rstrip()
        exclude_set.append(line)
        if ("src/classes" in line) or ("src/pages" in line):
            exclude_set.append(line+"-meta.xml")
exclude_set.insert(0, 'src/package.xml')
print exclude_set
# git ls-files > files_to_include.txt
buildfile = open("buildfile_deletesrc.xml", 'r')
temp = buildfile.readlines()
buildfile.close()

# Insert all files not included in exclude_set inside the <delete> tag
include_file = open('files_to_include.txt', 'r')
for line in include_file:
  if line.rstrip() not in exclude_set:
    if 'src' in line:
        line = line.rstrip()
        temp.insert(17, '        <include name="' + line + '"/>\n')
include_file.close()
#for line in temp:
    #print(line)
# ----- new list done.

# ----- Writes new list file to buildfile_deletesrc.xml
with open("buildfile_deletesrc.xml", 'w') as buildfile:
    buildfile.writelines(temp)
