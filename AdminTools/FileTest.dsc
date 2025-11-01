FileCopyTest:
    type: task
    script:
    - define startingPath <element[../Kingdoms]>

    # Test folder copy
    - filecopy origin:<[startingPath]>/some_folder destination:scripts save:folderCopy
    - narrate format:debug "Folder copy status: <entry[folderCopy].success>"

    # Test file copy
    - filecopy origin:<[startingPath]>/some_file destination:scripts/some_folder save:filecopy
    - narrate format:debug "File copy status: <entry[fileCopy].success>"