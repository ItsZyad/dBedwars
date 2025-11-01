FileCopyTest:
    type: task
    script:
    # Test folder copy
    - ~filecopy origin:../Kingdoms/some_folder destination:scripts overwrite save:folderCopy
    - narrate format:debug "Folder copy status: <entry[folderCopy].success>"

    # Test file copy
    - ~filecopy origin:../Kingdoms/some_file.txt destination:scripts/some_folder overwrite save:filecopy
    - narrate format:debug "File copy status: <entry[fileCopy].success>"