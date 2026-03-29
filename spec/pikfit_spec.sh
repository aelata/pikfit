CMD="../pikfit"

Describe '"pikfit"'
  cat << END > test.pikchr
line; box "Hello!"; arrow;
END
  cat << END > test.pic
.PS
line; box "Hello!"; arrow;
.PE
END
  cat << 'END' > test-m4.pikchr
define(`Hello', ``Hi'')
line; box "Hello!"; arrow;
END
  cat << 'END' > test.m4
define(`Hello', ``Hi'')
END

  It 'wraps pikchr/dpic output in a <figure> tag.'
    When run $CMD test.pikchr

    The status should be success
    The output should include "<figure"
    The output should include "</figure>"
  End

  It 'saves output to an HTML file with "-o PREFIX".'
    When run $CMD -o out test.pikchr

    The status should be success
    The output should include "</svg>"
    The output should include "</figure>"
    The contents of file "out.html" should include "</svg>"
    The contents of file "out.html" should include "</figure>"
  End
  rm -f out.html

  It 'saves output to an SVG file with "-A N -o PREFIX".'
    When run $CMD -A N -o out test.pikchr

    The status should be success
    The output should include "</svg>"
    The output should not include "</figure>"
    The contents of file "out.svg" should include "</svg>"
    The contents of file "out.svg" should not include "</figure>"
  End
  rm -f out.svg

  It 'center-aligns a figure by default or with "-A C".'
    When run $CMD test.pikchr

    The status should be success
    The output should include \
  "<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;margin:auto"
    The output should include "</figure>"
  End

  It 'left-aligns a figure with "-A L".'
    When run $CMD -A L test.pikchr

    The status should be success
    The output should include \
  "<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;margin-right:auto"
    The output should include "</figure>"
  End

  It 'right-aligns a figure with "-A R".'
    When run $CMD -A R test.pikchr

    The status should be success
    The output should include \
  "<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;margin-left:auto"
    The output should include "</figure>"
  End

  It 'does not aligns a figure (no "<figure>" tag) with "-A N".'
    When run $CMD -A N test.pikchr

    The status should be success
    The output should include \
  "<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;'"
    The output should not include "</figure>"
  End

  It 'uses the class "pikfit" for a figure by default.'
    When run $CMD test.pikchr

    The status should be success
    The output should include "<figure class='pikfit' "
  End

  It 'sets the class to use with "-C CLASS".'
    When run $CMD -C pikfit_0 test.pikchr

    The status should be success
    The output should include "<figure class='pikfit_0' "
  End

  It 'keeps intermediate files with "-K".'
    When run $CMD -K test.pikchr

    The status should be success
    The output should include "</figure>"
  End
  rm -f test_.{pikchr,cout,cerr}

  It 'adds style to svg with "-S STYLE".'
    When run $CMD -A N -S "font-family:sans-serif;" test.pikchr

    The status should be success
    The output should include \
  "<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;font-family:sans-serif;'"
  End

  It 'sets the width of a figure with "-W WIDTH".'
    When run $CMD -W 50% test.pikchr

    The status should be success
    The output should include \
"<svg xmlns='http://www.w3.org/2000/svg' style='font-size:initial;width:50%;"
    The output should include "</figure>"
  End

  It 'sets alternative text with "--alt=TEXT".'
    When run $CMD --alt=example test.pikchr

    The status should be success
    The output should include '<svg role="img" aria-label="example" '
    The output should include "</figure>"
  End

  It 'sets a figure caption with "--caption=TEXT".'
    When run $CMD --caption=example test.pikchr

    The status should be success
    The output should include '<svg role="img" aria-label="example" '
    The output should include '>example</figcaption>'
    The output should include "</figure>"
  End

  It 'defines ".hide" with "--dothide".'
    When run $CMD --dothide test.pikchr

    The status should be success
    The output should include "<style> .hide { display: none; } </style>"
    The output should include "<svg "
    The output should include "</figure>"
  End

  It 'preprocesses code with "--m4".'
    When run $CMD --m4 test-m4.pikchr

    The status should be success
    The output should include ">Hi!</text>"
    The output should include "</figure>"
  End

  It 'sets arguments for "m4" with "--m4-args=ARGS".'
    When run $CMD --m4-args="test.m4" test.pikchr

    The status should be success
    The output should include ">Hi!</text>"
    The output should include "</figure>"
  End

  It 'uses pikchr as a pic engine with "--pikchr" (default).'
    When run $CMD --pikchr test.pikchr

    The status should be success
    The output should include 'class="pikchr"'
    The output should include 'data-pikchr-date='
    The output should include "</figure>"
  End

  It 'sets margin with "-M MARGIN" for pikchr.'
    When run $CMD -K -M 1mm test.pikchr

    The status should be success
    The output should include "</figure>"
    The contents of file "test_.pikchr" should include "margin = 1mm;"
  End
  rm -f test_.{pikchr,cout,cerr}

  It 'uses dpic as a pic engine with "--dpic".'
    When run $CMD --dpic test.pic

    The status should be success
    The output should include '<!-- Creator: dpic'
    The output should include "</figure>"
  End

  It 'adds ".PS" and ".PE" before and after code with "--enclose" for dpic.'
    When run $CMD --dpic --enclose test.pikchr

    The status should be success
    The output should include "<svg "
    The output should include "</figure>"
  End

  It 'shows usage without arguments.'
    When run $CMD

    The status should be success
    The output should include "Usage: pikfit"
  End

  It 'shows usage with "-h" or "--help" as the first argument.'
    When run $CMD -h

    The status should be success
    The output should include "Usage: pikfit"
  End

  It 'shows version information with "-v" or "--version" as the first argument.'
    When run $CMD -v

    The status should be success
    The output should start with "pikfit version"
  End

  It 'does nothing and exits with "-n" or "--dry-run" as the first argument.'
    When run $CMD -n

    The status should be success
    The length of output should equal 0
    The length of error should equal 0
  End

  rm -f test.pikchr test.pic test-m4.pikchr test.m4
End
