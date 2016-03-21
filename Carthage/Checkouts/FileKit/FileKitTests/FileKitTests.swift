//
//  FileKitTests.swift
//  FileKitTests
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
import FileKit

class FileKitTests: XCTestCase {

    // MARK: - Path

    func testFindingPaths() {
        let homeFolders = Path.UserHome.find(searchDepth: 0) { $0.isDirectory }
        XCTAssertFalse(homeFolders.isEmpty, "Home folder is not empty")

        let rootFiles = Path.Root.find(searchDepth: 1) { !$0.isDirectory }
        XCTAssertFalse(rootFiles.isEmpty)
    }

    func testPathStringLiteralConvertible() {
        let a  = "/Users" as Path
        let b: Path = "/Users"
        let c = Path("/Users")
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(b, c)
    }

    func testPathStringInterpolationConvertible() {
        let path: Path = "\(Path.UserTemporary)/testfile_\(10)"
        XCTAssertEqual(path.rawValue, Path.UserTemporary.rawValue + "/testfile_10")
    }

    func testPathEquality() {
        let a: Path = "~"
        let b: Path = "~/"
        let c: Path = "~//"
        let d: Path = "~/./"
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(a, d)
    }

    func testStandardizingPath() {
        let a: Path = "~/.."
        let b: Path = "/Users"
        XCTAssertEqual(a.standardized, b.standardized)
    }

    func testPathIsDirectory() {
        let d = Path.SystemApplications
        XCTAssertTrue(d.isDirectory)
    }

    func testSequence() {
        var i = 0
        let parent = Path.UserTemporary
        for _ in parent {
            i++
        }
        print("\(i) files under \(parent)")

        i = 0
        for (_, _) in Path.UserTemporary.enumerate() {
            i++
        }
    }

    func testPathExtension() {
        var path = Path.UserTemporary + "file.txt"
        XCTAssertEqual(path.pathExtension, "txt")
        path.pathExtension = "pdf"
        XCTAssertEqual(path.pathExtension, "pdf")
    }

    func testPathParent() {
        let a: Path = "/"
        let b: Path = a + "Users"
        XCTAssertEqual(a, b.parent)
    }

    func testPathChildren() {
        let p: Path = "/Users"
        XCTAssertNotEqual(p.children(), [])
    }

    func testPathRecursiveChildren() {
        let p: Path = Path.UserTemporary
        let children = p.children(recursive: true)
        XCTAssertNotEqual(children, [])
    }

    func testRoot() {

        let root = Path.Root
        XCTAssertTrue(root.isRoot)

        XCTAssertEqual(root.standardized, root)
        XCTAssertEqual(root.parent, root)

        var p: Path = Path.UserTemporary
        XCTAssertFalse(p.isRoot)

        while !p.isRoot { p = p.parent }
        XCTAssertTrue(p.isRoot)

        let empty = Path("")
        XCTAssertFalse(empty.isRoot)
        XCTAssertEqual(empty.standardized, empty)

        XCTAssertTrue(Path("/.").isRoot)
        XCTAssertTrue(Path("//").isRoot)
    }

    func testFamily() {
        let p: Path = Path.UserTemporary
        let children = p.children()

        guard let child  = children.first else {
            XCTFail("No child into \(p)")
            return
        }
        XCTAssertTrue(child.isAncestorOfPath(p))
        XCTAssertTrue(p.isChildOfPath(child))

        XCTAssertFalse(p.isAncestorOfPath(child))
        XCTAssertFalse(p.isAncestorOfPath(p))
        XCTAssertFalse(p.isChildOfPath(p))

        let directories = children.filter { $0.isDirectory }

        guard let directory  = directories.first, childOfChild = directory.children().first else {
            XCTFail("No child of child into \(p)")
            return
        }
        XCTAssertTrue(childOfChild.isAncestorOfPath(p))
        XCTAssertFalse(p.isChildOfPath(childOfChild, recursive: false))
        XCTAssertTrue(p.isChildOfPath(childOfChild, recursive: true))


        // common ancestor
        XCTAssertTrue(p.commonAncestor(Path.Root).isRoot)
        XCTAssertEqual(.UserDownloads <^> .UserDocuments, Path.UserHome)
        XCTAssertEqual(("~/Downloads" <^> "~/Documents").rawValue, "~")
    }

    func testPathAttributes() {

        let a = .UserTemporary + "test.txt"
        try! "Hello there, sir" |> TextFile(path: a)
        let b = .UserTemporary + "TestDir"
        try! b.createDirectory()

        for p in [a, b] {
            print(p.creationDate)
            print(p.modificationDate)
            print(p.ownerName)
            print(p.ownerID)
            print(p.groupName)
            print(p.groupID)
            print(p.extensionIsHidden)
            print(p.posixPermissions)
            print(p.fileReferenceCount)
            print(p.fileSize)
            print(p.filesystemFileNumber)
            print(p.fileType)
            print("")
        }
    }

    func testPathSubscript() {
        let path = "~/Library/Preferences" as Path

        let a = path[0]
        XCTAssertEqual(a, "~")

        let b = path[2]
        XCTAssertEqual(b, path)
    }

    func testAddingPaths() {
        let a: Path = "~/Desktop"
        let b: Path = "Files"
        XCTAssertEqual(a + b, "~/Desktop/Files")
    }

    func testPathPlusEquals() {
        var a: Path = "~/Desktop"
        a += "Files"
        XCTAssertEqual(a, "~/Desktop/Files")
    }

    func testPathSymlinking() {
        do {
            let testDir: Path = .UserTemporary + "filekit_test_symlinking"

            if testDir.exists && !testDir.isDirectory {
                try testDir.deleteFile()
                XCTAssertFalse(testDir.exists)
            }

            try testDir.createDirectory()
            XCTAssertTrue(testDir.exists)

            let testFile = TextFile(path: testDir + "test_file.txt")
            try "FileKit test" |> testFile
            XCTAssertTrue(testFile.exists)

            let symDir = testDir + "sym_dir"
            if symDir.exists && !symDir.isDirectory {
                try symDir.deleteFile()
            }
            try symDir.createDirectory()

            // "/temporary/symDir/test_file.txt"
            try testFile =>! symDir

            let symPath = symDir + testFile.name
            XCTAssertTrue(symPath.isSymbolicLink)

            let symPathContents = try String(contentsOfPath: symPath)
            XCTAssertEqual(symPathContents, "FileKit test")

            let symLink = testDir + "test_file_link.txt"
            try testFile =>! symLink
            XCTAssertTrue(symLink.isSymbolicLink)

            let symLinkContents = try String(contentsOfPath: symLink)
            XCTAssertEqual(symLinkContents, "FileKit test")

        } catch {
            XCTFail(String(error))
        }
    }

    func testPathOperators() {
        let p: Path = "~"
        let ps = p.standardized
        XCTAssertEqual(ps, p%)
        XCTAssertEqual(ps.parent, ps^)
    }

    func testCurrent() {
        let oldCurrent: Path = .Current
        let newCurrent: Path = .UserTemporary

        XCTAssertNotEqual(oldCurrent, newCurrent) // else there is no test

        Path.Current = newCurrent
        XCTAssertEqual(Path.Current, newCurrent)

        Path.Current = oldCurrent
        XCTAssertEqual(Path.Current, oldCurrent)
    }

    func testChangeDirectory() {
        Path.UserTemporary.changeDirectory {
            XCTAssertEqual(Path.Current, Path.UserTemporary)
        }

        Path.UserDesktop </> {
            XCTAssertEqual(Path.Current, Path.UserDesktop)
        }

        XCTAssertNotEqual(Path.Current, Path.UserTemporary)
    }

    func testVolumes() {
        var volumes = Path.volumes()
        XCTAssertFalse(volumes.isEmpty, "No volume")

        for volume in volumes {
            XCTAssertNotNil("\(volume)")
        }

        volumes = Path.volumes(.SkipHiddenVolumes)
        XCTAssertFalse(volumes.isEmpty, "No visible volume")

        for volume in volumes {
            XCTAssertNotNil("\(volume)")
        }
    }

    func testURL() {
        let path: Path = .UserTemporary
        let URL = path.URL
        if let pathFromUrl = Path(URL: URL) {
            XCTAssertEqual(pathFromUrl, path)

            let subPath = pathFromUrl + "test"
            XCTAssertEqual(Path(URL: URL.URLByAppendingPathComponent("test")), subPath)
        }
        else {
            XCTFail("Not able to create Path from URL")
        }
    }

    func testBookmarkData() {
        let path: Path = .UserTemporary
        XCTAssertNotNil(path.bookmarkData)

        if let bookmarkData = path.bookmarkData {
            if let pathFromBookmarkData = Path(bookmarkData: bookmarkData) {
                XCTAssertEqual(pathFromBookmarkData, path)
            }
            else {
                XCTFail("Not able to create Path from Bookmark Data")
            }
        }
    }

    func testTouch() {
        let path: Path = .UserTemporary + "filekit_test.touch"
        do {
            if path.exists { try path.deleteFile() }
            XCTAssertFalse(path.exists)

            try path.touch()
            XCTAssertTrue(path.exists)

            guard let modificationDate = path.modificationDate else {
                XCTFail("Failed to get modification date")
                return
            }

            sleep(1)

            try path.touch()

            guard let newModificationDate = path.modificationDate else {
                XCTFail("Failed to get modification date")
                return
            }

            XCTAssertTrue(modificationDate < newModificationDate)

        } catch {
            XCTFail(String(error))
        }
    }
    
    func testCreateDirectory() {
        let dir: Path = .UserTemporary + "filekit_testdir"

        if dir.exists { try! dir.deleteFile() }

        defer {
            if dir.exists { try! dir.deleteFile() }
        }
        
        do {
            XCTAssertFalse(dir.exists)
            try dir.createDirectory()
            XCTAssertTrue(dir.exists)
        } catch {
            XCTFail(String(error))
        }
        
        do {
            XCTAssertTrue(dir.exists)
            try dir.createDirectory(withIntermediateDirectories: false)
            XCTFail("must throw exception")
        } catch FileKitError.CreateDirectoryFail {
            print("Create directory fail ok")
        } catch {
            XCTFail("Unknown error: " + String(error))
        }
        
        do {
            XCTAssertTrue(dir.exists)
            try dir.createDirectory(withIntermediateDirectories: true)
            XCTAssertTrue(dir.exists)
        } catch {
            XCTFail("Unexpected error: " + String(error))
        }

    }

    func testWellKnownDirectories() {
        XCTAssertTrue(Path.UserHome.exists)
        XCTAssertTrue(Path.UserTemporary.exists)
        XCTAssertTrue(Path.UserCaches.exists)

        XCTAssertFalse(Path.ProcessTemporary.exists)
        XCTAssertFalse(Path.UniqueTemporary.exists)
        XCTAssertNotEqual(Path.UniqueTemporary, Path.UniqueTemporary)
    }

    // MARK: - TextFile

    let tf = TextFile(path: .UserTemporary + "filekit_test.txt")

    func testFileName() {
        XCTAssertEqual(TextFile(path: "/Users/").name, "Users")
    }

    func testTextFileExtension() {
        XCTAssertEqual(tf.pathExtension, "txt")
    }

    func testTextFileExists() {
        do {
            try tf.create()
            XCTAssertTrue(tf.exists)
        } catch {
            XCTFail(String(error))
        }
    }

    func testWriteToTextFile() {
        do {
            try tf.write("This is some test.")
            try tf.write("This is another test.", atomically: false)
        } catch {
            XCTFail(String(error))
        }
    }

    func testTextFileOperators() {
        do {
            let text = "FileKit Test"

            try text |> tf
            var contents = try tf.read()
            XCTAssertTrue(contents.hasSuffix(text))

            try text |>> tf
            contents = try tf.read()
            XCTAssertTrue(contents.hasSuffix(text + "\n" + text))

        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - FileType

    func testFileTypeComparable() {
        let textFile1 = TextFile(path: .UserTemporary + "filekit_test_comparable1.txt")
        let textFile2 = TextFile(path: .UserTemporary + "filekit_test_comparable2.txt")
        do {
            try "1234567890" |> textFile1
            try "12345"      |> textFile2
            XCTAssert(textFile1 > textFile2)

        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - FilePermissions

    func testFilePermissions() {
        let swift: Path = "/usr/bin/swift"
        if swift.exists {
            XCTAssertTrue(swift.filePermissions.contains([.Read, .Execute]))
        }

        let file: Path = .UserTemporary + "filekit_test_filepermissions"

        do {
            try file.createFile()
            XCTAssertTrue(file.filePermissions.contains([.Read, .Write]))
        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - DictionaryFile

    let dictionaryFile = DictionaryFile(path: .UserTemporary + "filekit_test_dictionary.plist")

    func testWriteToDictionaryFile() {
        do {
            let dict = NSMutableDictionary()
            dict["FileKit"] = true
            dict["Hello"] = "World"

            try dictionaryFile.write(dict)
            let contents = try dictionaryFile.read()
            XCTAssertEqual(contents, dict)

        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - ArrayFile

    let arrayFile = ArrayFile(path: .UserTemporary + "filekit_test_array.plist")

    func testWriteToArrayFile() {
        do {
            let array: NSArray = ["ABCD", "WXYZ"]

            try arrayFile.write(array)
            let contents = try arrayFile.read()
            XCTAssertEqual(contents, array)

        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - DataFile

    let dataFile = DataFile(path: .UserTemporary + "filekit_test_data")

    func testWriteToDataFile() {
        do {
            let data = ("FileKit test" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
            try dataFile.write(data)
            let contents = try dataFile.read()
            XCTAssertEqual(contents, data)
        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - String+FileKit

    let stringFile = File<String>(path: .UserTemporary + "filekit_stringtest.txt")

    func testStringInitializationFromPath() {
        do {
            let message = "Testing string init..."
            try stringFile.write(message)
            let contents = try String(contentsOfPath: stringFile.path)
            XCTAssertEqual(contents, message)
        } catch {
            XCTFail(String(error))
        }
    }

    func testStringWriting() {
        do {
            let message = "Testing string writing..."
            try message.writeToPath(stringFile.path)
            let contents = try String(contentsOfPath: stringFile.path)
            XCTAssertEqual(contents, message)
        } catch {
            XCTFail(String(error))
        }
    }

    // MARK: - Image

    let img = Image(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/nvzqz/FileKit/assets/logo.png")!) ?? Image()

    func testImageWriting() {
        do {
            let path: Path = .UserTemporary + "filekit_imagetest.png"
            try img.writeToPath(path)
        } catch {
            XCTFail(String(error))
        }
    }

}
