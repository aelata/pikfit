Describe 'utils:'
  Include ../pikfit

  Describe '"quit"'
    It 'prints arguments to the standard error and quits.'
      When run quit "first line" "second line"

      The status should not be success
      The line 1 of stderr should equal "first line"
      The line 2 of stderr should equal "second line"
    End
  End

  Describe '"array_append_file"'
    printf -- '-$L1 &>"`\n'" <L2 \\;'#| \n" > test.txt
    It "appends lines in a file to a global array."
      o1="$(cat test.txt)"
      o2=()
      array_append_file o2 "test.txt"

      The first line of variable o1 should equal "${o2[0]}"
      The second line of variable o1 should equal "${o2[1]}"
    End

    printf -- '-$L1 &>"`\n'" <L2 \\;'#| "  > test-.txt
    It "appends lines in a file without a newline at the end of file."
      o1="$(cat test-.txt)"
      o2=()
      array_append_file o2 "test-.txt"

      The first line of variable o1 should equal "${o2[0]}"
      The second line of variable o1 should equal "${o2[1]}"
    End

    printf '%s\n' '$(touch HACKED)' 'xyz"); touch HACKED;' \
'`touch HACKED`' > inject.txt
    It "rejects some injections from file contents."
      a=()
      array_append_file a "inject.txt"

      The variable a[0] should equal '$(touch HACKED)'
      The variable a[1] should equal 'xyz"); touch HACKED;'
      The variable a[2] should equal '`touch HACKED`'
      The file HACKED should not be exist
    End

    rm test.txt test-.txt inject.txt
  End

  Describe '"array_append_str"'
    It "appends words from a string to a global array."
      a=()
      array_append_str a "-M 1pt -W 75%"

      The value "${#a[@]}" should equal 4
      The variable a[0] should equal "-M"
      The variable a[3] should equal "75%"
    End

    It "appends words with quoted spaces."
      a=()
      array_append_str a ' --caption="short caption" --alt "alt text" '

      The value "${#a[@]}" should equal 3
      The variable a[0] should equal "--caption=short caption"
      The variable a[2] should equal "alt text"
    End

    It "rejects some injections from a string."
      s='$(touch HACKED) ; touch HACKED; `touch HACKED`'
      a=()
      array_append_str a "$s"

      The value "${#a[@]}" should equal 7
      The variable a[*] should equal "$s"
      The variable a[1] should equal 'HACKED)'
      The variable a[4] should equal 'HACKED;'
      The variable a[6] should equal 'HACKED`'
      The file HACKED should not be exist
    End
  End

  Describe '"array_append_glob"'
    It "appends the name of existing files to a global array."
      FILES="a.{1,2,5,7} b.1"
      eval touch $FILES
      a=()
      p=("a.1" "a.2" "a.3" "a.4" "a.5")
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a.1 a.2 a.5"
      The variable a[0] should equal "a.1"
      The variable a[2] should equal "a.5"

      eval rm -rf "$FILES"
    End

    It "appends filenames, which may not unique or sorted (without \"| sort -zuV\")."
      FILES="a.{1,2,5,7} b.1"
      eval touch $FILES
      p=("b.1" "a.3" "a.5" "a.1" "b.1")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "b.1 a.5 a.1 b.1"
      The variable a[0] should equal "b.1"
      The variable a[3] should equal "b.1"
      The variable a[4] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends filenames with glob patterns."
      FILES="a.{2..5} a.11 b.{9..11} c.2 d.11"
      eval touch $FILES
      p=("?.2" "*.11" "a.[45]")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a.2 c.2 a.11 b.11 d.11 a.4 a.5"
      The variable a[0] should equal "a.2"
      The variable a[4] should equal "d.11"
      The variable a[7] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends filenames with brace patterns."
      FILES="a.2 b.{1..9} c.3"
      eval touch $FILES
      p=("b.{7,9}" "b.{2..4}")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "b.7 b.9 b.2 b.3 b.4"
      The variable a[0] should equal "b.7"
      The variable a[4] should equal "b.4"
      The variable a[5] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends filenames with brace and glob patterns."
      FILES="a.{1..5} b.{1..5} ab.{1..5}"
      eval touch $FILES
      p=("?.{1,3}" "*.3")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a.1 b.1 a.3 b.3 a.3 ab.3 b.3"
      The variable a[0] should equal "a.1"
      The variable a[3] should equal "b.3"
      The variable a[6] should equal "b.3"
      The variable a[7] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends filenames with spaces, which must be quoted when specifying arguments."
      FILES="'a b'.{11,1,2,3} 'b c'.{11,1,2,3}"
      eval touch $FILES
      p=("'a b'.?" "*.3")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a b.1 a b.2 a b.3 a b.3 b c.3"
      The variable a[0] should equal "a b.1"
      The variable a[4] should equal "b c.3"
      The variable a[5] should be undefined

      eval rm -rf $FILES
    End

    It "appends filenames in directories, which name contain spaces."
      TMP_DIR="tmp dir_$$"
      mkdir "$TMP_DIR"
      FILES="'$TMP_DIR'/a.{2,9,11..13}"

      eval touch $FILES
      p=("'$TMP_DIR'/*.?")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "$TMP_DIR/a.2 $TMP_DIR/a.9"
      The variable a[0] should equal "$TMP_DIR/a.2"
      The variable a[1] should equal "$TMP_DIR/a.9"
      The variable a[2] should be undefined

      rm -rf "$TMP_DIR"
    End

    It "appends Unicode filenames."
      FILES="あい.1 あい.2 あう.1 あう.2"
      eval touch $FILES
      p=("あ*.2")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "あい.2 あう.2"
      The variable a[0] should equal "あい.2"
      The variable a[1] should equal "あう.2"
      The variable a[2] should be undefined

      eval rm -rf "$FILES"
    End

    It "rejects some injections from filenames."
      FILES=$'ace \'$(touch HACKED)\' abc aab \'xyz");touch HACKED;\' \'`touch HACKED`\' abd'
      eval touch $FILES
      a=()
      array_append_glob a "ab*"

      The variable a[*] should equal "abc abd"
      The variable a[0] should equal "abc"
      The file HACKED should not be exist

      eval rm -rf "$FILES"
    End
  End

  Describe '"html_echo"'
    It "prints arguments while escaping HTML special characters."
      When run html_echo \
'<SCRIPT>' 'document.write("v=" + (1 & 2));' '</SCRIPT>'

      The status should be success
      The line 1 of output should equal "&lt;SCRIPT&gt;"
      The line 2 of output should equal \
"document.write(&quot;v=&quot; + (1 &amp; 2));"
      The line 3 of output should equal "&lt;/SCRIPT&gt;"
    End
  End

  Describe '"head1"'
    It "prints the first line of the command output."
      When run head1 "bash" "--version"

      The status should be success
      The line 1 of output should include "bash"
      The line 1 of output should include "version"
      The line 2 of output should be undefined
    End
  End
End
