#!/bin/sh
#
#!
# @file ./config.sh
#
# @brief Configure Boot JVM.
#
# Shell script to configure which features are in the compiled code.
# This build happens in several phases:
#
# <ul>
# <li>
# <b>(1)</b> Pre-formatted documentation
# </li>
# <li>
# <b>(2)</b> Java Setup
# </li>
# <li>
# <b>(3)</b> C Compilation and Document Compilation Setup
# </li>
# <li>
# <b>(4)</b> Startup Library (bootclasspath) Java classes
# </li>
# <li>
# <b>(5)</b> Source code build-- Invokes 'build.sh', which may be
#                         used for all further compilations.
# </li>
# </ul>
#
# Remember that if you add a Java source file, a C source or header
# file, or a shell script, you should run this script again so that
# the @b config directory roster locates the update.  This way,
# 'doxygen' will automatically incorporate it into the documentation
# suite.
#
# @todo Support the following input parameter format:
#
# Input:   [hwvendor [wordwidth [osname]]]
#
# These optional positional parameters contain specific token values,
# which may change from one release to the next.  Initially, they are
# as follows.  For current actual supported platform values, please
# refer to parsing of positional parms $1 and $2 and $3 below.
#
# <ul>
#         <li>hwvendor     Keyword for supported hardware platform.
#                          Initially @b sparc and @b intel
#
#         </li>
#         <li>wordwidth    Keyword for hardware word size.
#                          Initialiy either @b 32 and @b 64
#         </li>
#         <li>osname       Keyword for operating system name.
#                          Initially @b solaris and @b linux and
#                          @b windows.
#         </li>
# </ul>
#
# These may evolve over time, and not every combination of these
# is valid.  The initial valid combinations are:
#
# (hwvendor, wordwidth, osname) ::=   one of these combinations:
#
# <ul>
#     <li>(sparc, 32, solaris)
#     </li>
#     <li>(sparc, 64, solaris)
#     </li>
#     <li>(sparc, 32, linux)
#     </li>
#     <li>(sparc, 64, linux)
#     </li>
#     <li>(intel, 32, solaris)
#     </li>
#     <li>(intel, 32, linux)
#     </li>
#     <li>(intel, 64, solaris)
#     </li>
#     <li>(intel, 64, linux)
#     </li>
#     <li>(intel, 32, windows)
#     </li>
#     <li>(amd,   64, windows)... JDK for AMD64 coming soon from Sun.
#     </li>
# </ul>
#
#
# @todo  A Windows .BAT version of this script needs to be written
#
#
# @section Control
#
# \$URL: https://svn.apache.org/path/name/config.sh $ \$Id: config.sh 0 09/28/2005 dlydick $
#
# Copyright 2005 The Apache Software Foundation
# or its licensors, as applicable.
#
# Licensed under the Apache License, Version 2.0 ("the License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied.
#
# See the License for the specific language governing permissions
# and limitations under the License.
#
# @version \$LastChangedRevision: 0 $
#
# @date \$LastChangedDate: 09/28/2005 $
#
# @author \$LastChangedBy: dlydick $
#         Original code contributed by Daniel Lydick on 09/28/2005.
#
# @section Reference
#
#/ /* 
# (Use  #! and #/ with dox_filter.sh to fool Doxygen into
# parsing this non-source text file for the documentation set.
# Use the above open comment to force termination of parsing
# since it is not a Doxygen-style 'C' comment.)
#
#
###################################################################
#
# Script setup
#
chmod -w $0 ./echotest.sh

. ./echotest.sh

# `dirname $0` for shells without that utility
PGMDIR=`expr "${0:-.}/" : '\(/\)/*[^/]*//*$'  \| \
             "${0:-.}/" : '\(.*[^/]\)//*[^/][^/]*//*$' \| .`
PGMDIR=`cd $PGMDIR; pwd`

# `basename $0` for shells without that utility
PGMNAME=`expr "/${0:-.}" : '\(.*[^/]\)/*$' : '.*/\(..*\)' \|\
              "/${0:-.}" : '\(.*[^/]\)/*$' : '.*/\(..*\)' \| \
              "/${0:-.}" : '.*/\(..*\)'`

###################################################################
#
# Constant values
#
PROGRAM_NAME="BootJVM"
PROGRAM_DESCRIPTION="Apache Harmony Bootstrap JVM"

###################################################################
#
# Introduction
#
tput clear
echo ""
echo "Welcome to the Apache Harmony Bootstrap JVM configurator!"
echo "========================================================="
echo ""
echo "You may run this utility as often as needed to configure or"
echo "reconfigure various parts of your installation of this project."
echo "There are several areas that will be configured with this tool:"
echo ""
echo "  (1) Pre-formatted documentation"
echo "  (2) Java compilation setup"
echo "  (3) C compilation and document compilation setup"
echo "  (4) Startup library (bootclasspath) Java classes"
echo "  (5) Project build"
echo ""
echo "Phases (2) and (3) will be configured every time, where"
echo "phases (1) and (4) need only be configured once, unless"
echo "there is a need to change something.  Phase (5) may be"
echo "run each time or not, as desired.  The most important"
echo "information from phases (2) and (3) is stored into the"
CFGH="config/config.h"
echo "configuration file '$CFGH' and are the ones"
echo "most likely to need adjustment from time to time."
echo ""
echo "Do you wish to read the introductory notes? [y,n] $echoc"
read readintro
echo ""

case $readintro in
    y|ye|yes|Y|YE|YES) READINTRO=1;;
    *)                 READINTRO=0;;
esac

if test 1 -eq $READINTRO
then
# Do not indent so that more text may be put on each line:

tput clear
echo ""
echo "Introductory Configuration Notes"
echo "--------------------------------"
echo ""
echo "The documentation for this project is created from information"
echo "stored literally within each source file.  Documentation tags are"
echo "used to frame each portion, which is extracted and formatted"
echo "with the C/C++ documentation tool called Doxygen."
echo ""
echo "Over the course of the development cycle, you may add or delete"
echo "source files:  Java source, C source, C headers, perhaps shell"
echo "scripts.  When this is done, the 'build.sh' scripts will"
echo "automatically pick up the changes after this script is run."
echo "The changes will be made available to the 'doxygen' and 'gcc'"
echo "as coordinated by the 'config/config_roster*' files, and"
echo "without assistance required from users."
echo ""
echo "The 'README' file in this directory contains much useful"
echo "information about which source files perform which function."
echo ""
echo "more... $echoc"
read dummy
echo ""
echo "This project was originally developed on a Solaris 9 platform."
echo "All C code was originally compiled there with the GCC C compiler."
echo "Your GCC compiler is located in"
echo ""
echo "\$ which gcc"
which gcc
echo ""
echo "If not found, the source be located at www.gnu.org.  Please use"
echo "version 3.3.2 or newer.  There are also compiled binary editions"
echo "of GCC available from numerous hardware vendors and/or their"
echo "user groups."
echo ""
echo "ready... $echoc"
read dummy
echo ""
echo "The 'build.sh dox' facility extracts the documentation from the"
echo "source code using 'doxygen'.  On your system, it is located in:"
echo ""
echo "\$ which doxygen"
which doxygen
echo ""
echo "If not found, binary distributions for numerous platforms are"
echo "located at: www.doxygen.org.  Please use version 1.4.4 or newer."
echo ""
echo "... End of introductory notes ..."
echo ""
echo "ready... $echoc"
read dummy
fi

###################################################################
#
# Set up phase 1:  Pre-formatted documentation
#
tput clear
echo ""
echo "Phase 1:  Pre-formatted documentation"
echo "-------------------------------------"
echo ""
echo ""
echo "The project documentation comes pre-formatted by 'doxygen'."
echo "It provides output in HTML format for a web browser, in Unix"
echo "man and Latex info formats, as well as RTF, and XML formats"
echo "for other access methods."
echo ""
echo "This documentation may also be derived from the source code at"
echo "any time by invoking the top-level project build option"
echo "'build.sh dox' or 'build.sh all'."
echo ""
echo "Developers working only on documentation may wish to _not_"
echo "install it, while most others may wish to do so for a starting"
echo "point for their work.  (Remember that documentation of source"
echo "files, functions, data types, and data structures is all part"
echo "of the development process.  Running 'build.sh dox' will refresh"
echo "the documentation suite with your current work.)"
echo ""
echo "more... $echoc"
read dummy
echo ""
echo "Once installed in the 'doc' directory, this information will"
echo "promptly be moved to a 'doc.ORIG' directory as a read-only"
echo "reference that is not changed during 'build.sh' operations."
echo "All documentation builds write their output to the 'doc'"
echo "directory, leaving 'doc.ORIG' untouched.  If you will be"
echo "regularly working with documentation changes, or if you do"
echo "not need a reference copy of the documentation, you may"
echo "safely remove this version."
echo ""
echo "more... $echoc"
read dummy
echo ""
echo "It is recommended that a typical user install the documentation"
echo "suite in manner described here and used it in this way until"
echo "accustomed to the use of the various tools."
echo ""
echo "If it has already been installed on a previous instance of"
echo "running '$PGMNAME', then it does not need to be installed again."
echo ""
echo "Do you wish to install pre-formatted documentation? [y,n] $echoc"
read prefmtdocs

###################################################################
#
# Set up and run phase 2:  Java compilation setup
#
tput clear
echo ""
echo "Phase 2:  Java compilation setup"
echo "--------------------------------"
echo ""
echo "This project uses your current Java J2SE compilation tools."
echo "Any JDK will do, as long as its compiler is called 'javac'"
echo "and it has an archiver utility called 'jar'.  It also needs"
echo "to have a class library of some description from which this"
echo "Java runtime will initially draw its library classes such as"
echo "java.lang.Object and other fundamental components.  These will,"
echo "over time, be replaced with classes native to the project."
echo ""
echo "$PGMNAME:  Testing JAVA_HOME..."

if test "" = "$JAVA_HOME"
then
    echo "$PGMNAME:  STOP!  Need to have JAVA_HOME defined first"
    exit 1
fi
echo "$PGMNAME:  JAVA_HOME okay: $JAVA_HOME"

echo "$PGMNAME:  Testing $JAVA_HOME..."

if test ! -d $JAVA_HOME/.
then
    echo "$PGMNAME:  JAVA_HOME directory does not exist"
fi

CRITICAL_PROGRAMS="jar javac" # javah java ... add as needed

echo "$PGMNAME:  Testing $JAVA_HOME/bin..."

rc=0
for binary in $CRITICAL_PROGRAMS
do
    if test ! -x $JAVA_HOME/bin/$binary
    then
     echo "$PGMNAME:  Critical program $JAVA_HOME/bin/$binary not found"
        rc=1
    fi
done
if test 0 -ne $rc
then
    exit 2
fi

echo "$PGMNAME:  Testing $JAVA_HOME/include..."

if test ! -d $JAVA_HOME/include
then
    echo "$PGMNAME:  Missing JDK include directory $JAVA_HOME/include"
    exit 3
fi

echo "$PGMNAME:  Testing $PGMDIR..."

if test ! -w .
then
 echo "$PGMNAME:  Cannot write to $PGMDIR.  Please change to read-write"
    exit 4
fi

echo "$PGMNAME:  Testing Java version..."

$JAVA_HOME/bin/java -version

echo  ""
echo  "Is this version of Java and JAVA_HOME satisfactory? [y,n] $echoc"
read libsetup
echo ""

case $libsetup in
    y|ye|yes|Y|YE|YES) ;;
    *)     echo ""
           echo "Remedy:  Change JAVA_HOME to desired JDK and try again"
           echo ""
           exit 5;;
esac

for dir in jvm libjvm main test jni jni/src/harmony/generic/0.0
do
    echo "$PGMNAME:  Testing Source Area $dir..."

    if test ! -d $dir/src
    then
        echo "$PGMNAME:  Missing '$PGMDIR/$dir/src' directory"
        exit 6
    fi
done

for dir in jvm jni/src/harmony/generic/0.0
do
    echo "$PGMNAME:  Testing Include Area $dir..."

    if test ! -d $dir/include
    then
        echo "$PGMNAME:  Missing '$PGMDIR/$dir/include' directory"
        exit 7
    fi
done

echo "$PGMNAME:  Testing Object Area..."
echo "$PGMNAME:  Setting up output area..."

echo ""
echo "$PGMNAME:  Enter name of JRE class library archive file,"
echo "              relative to JAVA_HOME ($JAVA_HOME)."
echo "              Use this format:  relative/pathname/filename.jar"

while true
do
    echo ""
    echo "           If the default is acceptable, enter an empty line:"
    echo ""
    $echon "JRE class library archive: [jre/lib/rt.jar] $echoc"
    read rtjarfile

    if test -z "$rtjarfile"
    then
        rtjarfile="jre/lib/rt.jar"
    fi

   if test ! -f $JAVA_HOME/$rtjarfile
   then
       echo ""
       echo "File not found: $JAVA_HOME/$rtjarfile"
       echo ""
       continue
   fi

   if test ! -r $JAVA_HOME/$rtjarfile
   then
       echo ""
       echo "Permission denied: $JAVA_HOME/$rtjarfile"
       echo ""
       continue
   fi

   (
       mkdir ${TMPDIR:-/tmp}/tmp.config.$$
       cd ${TMPDIR:-/tmp}/tmp.config.$$
       $JAVA_HOME/bin/jar xf $JAVA_HOME/$rtjarfile \
                             java/lang/Object.class
   )
   if test ! -r ${TMPDIR:-/tmp}/tmp.config.$$/java/lang/Object.class
   then
       rm -rf ${TMPDIR:-/tmp}/tmp.config.$$
       echo ""
       echo "Archive is missing java.lang.Object: $JAVA_HOME/$rtjarfile"
       echo ""
       continue
   fi
   rm -rf ${TMPDIR:-/tmp}/tmp.config.$$

   # JRE file correct
   break
done
RTJARFILE=$rtjarfile
CONFIG_RTJARFILE=$JAVA_HOME/$rtjarfile

###################################################################
#
# Set up phase 3:  C Compilation and Document Compilation Setup
#
tput clear
echo ""
echo "Phase 3:  C Compilation and Document Compilation Setup"
echo "------------------------------------------------------"
echo ""
echo "The following is a set of questions that tells the compiler"
echo "the release level of the project and which compile options"
echo "to use and tells the source code about certain features of"
echo "the CPU.  Further questions inform the compiler and linker"
echo "about which options to use for selected modular features"
echo "such as heap allocation and garbage collection."
echo ""
while true
do
    echo ""
    echo "  The release level is configured as:  MAJOR.MINOR.PATCHLEVEL"
    echo "  where each part of the tuple is"
    echo "  a numeric value of up to four digits."
    echo "  The only time it is important is"
    echo "  when a release is being made, at"
    echo "  which time the  tuple assigned by"
    echo "  the project management committee"
    echo "  must be used."
    echo ""
    $echon "  Enter the numeric MAJOR revision level:      $echoc"
    read RELEASE_MAJOR

    case $RELEASE_MAJOR in
        [0-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9] ) ;;
        *)     echo ""
               echo "Please use a numeric value for the MAJOR field"
               echo ""
               continue;;
    esac

    # Strip leading zeroes
    RELEASE_MAJOR=`expr 0 + $RELEASE_MAJOR`

    echo ""
    $echon "  Enter the numeric MINOR revision level:      $echoc"
    read RELEASE_MINOR

    case $RELEASE_MINOR in
        [0-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9] ) ;;
        *)     echo ""
               echo "Please use a numeric value for the MINOR field"
               echo ""
               continue;;
    esac

    # Strip leading zeroes
    RELEASE_MINOR=`expr 0 + $RELEASE_MINOR`

    echo ""
    $echon "  Enter the numeric PATCHLEVEL revision level: $echoc"
    read RELEASE_PATCHLEVEL

    case $RELEASE_PATCHLEVEL in
        [0-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9] ) ;;
        *)     echo ""
              echo "Please use a numeric value for the PATCHLEVEL field"
               echo ""
               continue;;
    esac

    # Strip leading zeroes
    RELEASE_PATCHLEVEL=`expr 0 + $RELEASE_PATCHLEVEL`

    # Valid tuple of three numbers entered
    RELEASE_LEVEL="$RELEASE_MAJOR.$RELEASE_MINOR.$RELEASE_PATCHLEVEL"
    break
done

echo "---"
echo "Valid release level: $RELEASE_LEVEL"


while true
do
    echo ""
    echo "  Enter hardware configuration of this platform:"
    echo ""
    HWLIST="Sun Sparc series, Intel x86 series[, add others here]"
    echo "  Hardware vendor name: $HWLIST"
    echo ""
    $echon "  Select [sparc,intel] $echoc"
    read hwvendor

    case $hwvendor in
        sparc) HWVENDOR=SPARC;;
        intel) HWVENDOR=INTEL;;
        *)     echo ""
               echo "Hardware vendor '$hwvendor' invalid"
               echo ""
               continue;;
    esac

    echo ""
    echo "  Architecture word width model:  32-bit word, 64-bit word"
    echo ""
    $echon "  Select [32,64] $echoc"
    read wordwidth

    case $wordwidth in
        32 | 64 ) WORDWIDTH=$wordwidth;;
        *)        echo ""
                  echo "Word width '$wordwidth' invalid"
                  echo ""
                  continue;;
    esac

    echo ""
    echo "  Operating system:  Solaris, Linux, Windows"
    echo ""
    $echon "  Select [solaris,linux,windows] $echoc"
    read osname

    case $osname in
        solaris) OSNAME=SOLARIS;;
        linux)   OSNAME=LINUX;;
        windows) OSNAME=WINDOWS;;
        *)       echo ""
                 echo "Operating system '$osname' invalid"
                 echo ""
                 continue;;
    esac

    # Check invalid combinations
    echo ""
    case $hwvendor in
        sparc)  if test "$osname" = "windows"
                then
                    echo "Combination invalid:  $hwvendor/$osname"
                    echo ""
                    continue
                fi;;

        intel)  if test "$wordwidth" = "64"
                then
                    echo "Combination unsupported: $hwvendor/$wordwidth"
                    echo ""
                    continue
                fi;;
    esac

    break # All other combinations valid

done

echo "---"
echo \
"Valid architecture:  HW=$hwvendor  Word=$wordwidth bits OS=$osname"


echo ""
echo "$PGMNAME:  Choose a heap allocation method:"
echo ""
echo "            simple-- Uses malloc(3) and free(3) only"
echo "            bimodal-- Augments 'simple' with large storage area"
echo "            other-- Roll your own, generates unresolved externals"

while true
do
    echo ""
    $echon "Heap allocation method: [simple,bimodal,other] $echoc"
    read heapalloc

    case $heapalloc in
        simple)  HEAPALLOC="HEAP_TYPE_SIMPLE";;
        bimodal) HEAPALLOC="HEAP_TYPE_SIMPLE";;
        other)   HEAPALLOC="HEAP_TYPE_OTHER";;

        *)       echo ""
                 echo "Heap allocation method '$heapalloc' invalid"
                 echo ""
                 continue;;
    esac
    break
done


echo ""
echo "$PGMNAME:  Choose a garbage collection method:"
echo ""
echo "            stub--  Only the API calls, no content"
echo "            other-- Roll your own, generates unresolved externals"

while true
do
    echo ""
    $echon "Garbage collection method: [stub,other] $echoc"
    read gcmethod

    case $gcmethod in
        stub)    GCMETHOD="GC_TYPE_STUB";;
        other)   GCMETHOD="GC_TYPE_OTHER";;

        *)       echo ""
                 echo "Garbage collection method '$gcmethod' invalid"
                 echo ""
                 continue;;
    esac
    break
done

###################################################################
#
# Set up phase 4: Extract startup classes for system bootstrap
#
# Extract selected classes from '$CONFIG_RTJARFILE' for use
# during system startup.  This is a convenient workaround for
# when the JAR extraction logic is not yet available.
#
# These classes are required for proper initialization of the
# JVM.  Any others, which are listed in 'src/jvmclass.h' may
# be included also.  The minimum set is:
#
#     #define JVM_STARTCLASS_JAVA_LANG_OBJECT "java/lang/Object"
#     #define JVM_STARTCLASS_JAVA_LANG_VOID   "java/lang/Void"
#     #define JVM_STARTCLASS_JAVA_LANG_STRING "java/lang/String"
#     #define JVM_STARTCLASS_JAVA_LANG_STRING "java/lang/Thread"
#
tput clear
echo ""
echo "Phase 4: Extract startup classes"
echo "--------------------------------"
echo ""
echo "The environment BOOTCLASSPATH is used to make selected classes"
echo "more easily accessible during runtime startup.  When installed,"
echo "a BOOTCLASSPATH directory decreases startup time significantly"
echo "by having fundamental classes ready to be loaded without having"
echo "to extract them from the class library.  A minimum set is needed"
echo "and a larger set is available if desired, although they are not"
echo "vital to normal startup scenarios.  This environment variable"
echo "may also be overridden on the 'bootjvm' command line."
echo ""

# Squeeze msg onto 80-columns (just a matter of text standards and form)
MSG80="Do you wish to set up the BOOTCLASSPATH library?"
echo  ""
$echon "$MSG80 [y,n] $echoc"
read libsetup

biglib=0
case $libsetup in
    y|ye|yes|Y|YE|YES)
        dosetupboot=1

        echo  ""
        echo "How much disk buffering do you wish"
     $echon "for the BOOTCLASSPATH directory to use? [less,more] $echoc"
        read libsize

        case $libsize in
            m|mo|mor|more|M|MO|MOR|MORE) biglib=1;;
            *)                           biglib=0;; # Redundant
        esac
        ;;

    *)  dosetupboot=0;;
esac

###################################################################
#
# Set up phase 5:  Build binary and documentation from source code
#
tput clear
echo ""
echo "Phase 5:  Build binary and documentation from source code"
echo "---------------------------------------------------------"
echo ""
echo "The code may be partitioned into several components and built"
echo "either all at once and/or by its various parts.  The top-level"
echo "build script has these same options, and using 'build.sh cfg'"
echo "will build what is requested here in addition to individual"
echo "selections.  The default option is 'build.sh cfg'.  Choosing"
echo "'all' declares that all components are to be built by the"
echo "default build option 'build.sh cfg'."
echo ""
echo "more... $echoc"
read dummy
echo ""
echo \
"The several options for building the code (answer 'yes' or 'no') are:"
echo ""
echo "    all--   Build the entire code tree, namely:"
echo ""
echo "    jvm--   Build the main development area"
echo "    libjvm--Build the static JVM library"
echo "    main--  Build the sample main() program (links 'libjvm.a')"
echo "    test--  Build the Java test code area"
echo "    jni--   Build the sample JNI code area (links 'libjvm.a')"
echo "    dox--   Build the documentation (using doxygen)"
echo ""
echo "A suggested combination for beginning users is 'jvm' and 'dox' to"
echo "build everything in one place and generate documentation changes"
echo "when appropriate."
echo ""
echo "A suggested combination for integrators is 'lib' and 'main' for"
echo "creating the JVM in a library and testing it out with 'main'."
echo ""
echo "A suggested combination for test case writers is 'jvm' and 'test'"
echo "for creating the JVM in a binary and adding test cases."
echo ""

SHOULDBUILD="Should 'build.sh' construct"
MSG80ALL="all:  $SHOULDBUILD the entire code tree?"
MSG80JVM="jvm:  $SHOULDBUILD the main develoment area?"
MSG80LIB="lib:  $SHOULDBUILD the static JVM library?"
MSG80MAIN="main: $SHOULDBUILD the sample main() program?"
MSG80TEST="test: $SHOULDBUILD the Java test code area?"
MSG80JNI="jni:  $SHOULDBUILD the sample JNI code area?"
MSG80DOX="dox:  $SHOULDBUILD the documentation area?"

BUILD_JVM=1
BUILD_LIB=1
BUILD_MAIN=1
BUILD_TEST=1
BUILD_JNI=1
BUILD_DOX=1

while true
do
    echo  ""
    $echon "$MSG80ALL [y,n] $echoc"
    read buildall

    case $buildall in
        y|ye|yes|Y|YE|YES)
           BUILD_ALLCODE=1
           ;;

        n|no|N|NO)
           BUILD_ALLCODE=0

           echo  ""
           $echon "$MSG80JVM [y,n] $echoc"
           read buildjvm
           case $buildjvm in
               y|ye|yes|Y|YE|YES) BUILD_JVM=1;;
               *)                 BUILD_JVM=0;;
           esac

           echo  ""
           $echon "$MSG80LIB [y,n] $echoc"
           read buildlib
           case $buildlib in
               y|ye|yes|Y|YE|YES) BUILD_LIB=1;;
               *)                 BUILD_LIB=0;;
           esac

           echo  ""
           $echon "$MSG80MAIN [y,n] $echoc"
           read buildmain
           case $buildmain in
               y|ye|yes|Y|YE|YES) BUILD_MAIN=1;;
               *)                 BUILD_MAIN=0;;
           esac

           echo  ""
           $echon "$MSG80TEST [y,n] $echoc"
           read buildmain
           case $buildmain in
               y|ye|yes|Y|YE|YES) BUILD_TEST=1;;
               *)                 BUILD_TEST=0;;
           esac

           echo  ""
           $echon "$MSG80JNI [y,n] $echoc"
           read buildjni
           case $buildjni in
               y|ye|yes|Y|YE|YES) BUILD_JNI=1;;
               *)                 BUILD_JNI=0;;
           esac

           echo  ""
           $echon "$MSG80DOX [y,n] $echoc"
           read builddox
           case $builddox in
               y|ye|yes|Y|YE|YES) BUILD_DOX=1;;
               *)                 BUILD_DOX=0;;
           esac
           ;;

        *) continue;;
    esac

    break
done
echo ""
echo ""
echo "The documentation creation process is independent of the"
echo "pre-formatted documentation installed into 'doc.ORIG'.  When"
echo "generated, it gets stored into the 'doc' directory without regard"
echo "for previous contents.  It may be generated either through the"
echo "pre-configured build process (per above question) or by direct"
echo "action from the top-level build command 'build.sh dox'.  When"
echo "time comes to generate documentation, there are several formats"
echo "available.  Most options may be used in combination to yield only"
echo "the desired formats.  Choosing 'all' configures every format."
echo ""
echo "more... $echoc"
read dummy
echo ""
echo "The several options for building various documentation formats"
echo "(answer 'yes' or 'no') are:"
echo ""
echo "            all--  Build documentation in every format, namely:"
echo ""
echo "            html-- Build HTML format docs (doc/html)"
echo "            latex--Build Latex info format docs (doc/latex)"
echo "            rtf--  Build RTF docs (doc/rtf)"
echo "            man--  Build man section 3 docs (doc/man/man3)"
echo "            xml--  Build XML format docs (doc/xml)"
echo ""
echo "(Note:  Choosing 'rtf' may cause doxygen to generate spurious"
echo "        messages, 'QGDict::hashAsciiKey: Invalid null key' on"
echo "        otherwise perfectly formatted documentation.  Reasons"
echo "        are not yet known.)"
echo ""
echo "A suggested combination for Unix users might be HTML and"
echo "either man page or latex formats."
echo ""
echo "A suggested combination for Windows users might be HTML and"
echo "RTF formats."
echo ""
echo "more... $echoc"
read dummy
echo ""
echo "Older versions of the NetScape HTML browser can do odd things to"
echo "newer versions of HTML code.  In particular, the persistent"
echo "versions 4.7X that are still widely used on many Unix systems"
echo "may experience difficulties.  The output of Doxygen may require"
echo "certain adjustments, particularly on presentation of code"
echo "fragments and other so-called 'verbatim' fragments."
echo ""

MSG80HTML="Do you need these adjustments done for your HTML browser?"
while true
do
    echo  ""
    $echon "$MSG80HTML [y,n] $echoc"
    read adjnetscape

    case $adjnetscape in
        y|ye|yes|Y|YE|YES) BUILD_HTML_ADJ_NETSCAPE47X=YES
                           break;;

        n|no|N|NO)         BUILD_HTML_ADJ_NETSCAPE47X=NO
                           break;;

        *)                 continue;;
    esac
done



SHOULDBUILD="Should 'build.sh dox' build"
MSG80ALL="all:    $SHOULDBUILD docs in every format?"
MSG80HTML="html:   $SHOULDBUILD HTML format docs (doc/html) ?"
MSG80LATEX="latex:  $SHOULDBUILD Latex info format docs (doc/latex) ?"
MSG80RTF="rtf:    $SHOULDBUILD RTF docs (doc/rtf) ?"
MSG80MAN="man:    $SHOULDBUILD man section 3 docs (doc/man/man3) ?"
MSG80XML="xml:    $SHOULDBUILD XML format docs (doc/xml) ?"

BUILD_HTML=YES
BUILD_LATEX=YES
BUILD_RTF=YES
BUILD_MAN=YES
BUILD_XML=YES

while true
do
    echo  ""
    $echon "$MSG80ALL [y,n] $echoc"
    read buildall

    case $buildall in
        y|ye|yes|Y|YE|YES)
           BUILD_ALLDOX=YES
           ;;

        n|no|N|NO)
           BUILD_ALLDOX=NO

           echo  ""
           $echon "$MSG80HTML [y,n] $echoc"
           read buildhtml
           case $buildhtml in
               y|ye|yes|Y|YE|YES) BUILD_HTML=YES;;
               *)                 BUILD_HTML=NO;;
           esac

           echo  ""
           $echon "$MSG80LATEX [y,n] $echoc"
           read buildlatex
           case $buildlatex in
               y|ye|yes|Y|YE|YES) BUILD_LATEX=YES;;
               *)                 BUILD_LATEX=NO;;
           esac

           echo  ""
           $echon "$MSG80RTF [y,n] $echoc"
           read buildrtf
           case $buildrtf in
               y|ye|yes|Y|YE|YES) BUILD_RTF=YES;;
               *)                 BUILD_RTF=NO;;
           esac

           echo  ""
           $echon "$MSG80MAN [y,n] $echoc"
           read buildman
           case $buildman in
               y|ye|yes|Y|YE|YES) BUILD_MAN=YES;;
               *)                 BUILD_MAN=NO;;
           esac

           echo  ""
           $echon "$MSG80XML [y,n] $echoc"
           read buildxml
           case $buildxml in
               y|ye|yes|Y|YE|YES) BUILD_XML=YES;;
               *)                 BUILD_XML=NO;;
           esac
           ;;

        *) continue;;
    esac

    break
done
echo ""

echo ""
echo "Do you also wish to build the configured components? [y,n] $echoc"
read buildnow
echo ""
echo  ""
$echon "$PGMNAME: Ready to configure and build... $echoc"
read doit
echo  ""

###################################################################
#
# Run phase 1:  Pre-formatted documentation
#
echo  ""
$echon "$PGMNAME: Starting to configure... $echoc"
sleep 3
echo  ""
echo  ""
echo  "$PGMNAME:  configuring project"
echo  ""
case $prefmtdocs in
    y|ye|yes|Y|YE|YES)
        PREFMTDOCSTAR="$PGMDIR/bootJVM-docs.tar"
        echo "$PGMNAME:  Testing $PREFMTDOCSTAR.gz"

        if test ! -r $PREFMTDOCSTAR.gz
        then
  echo "$PGMNAME:  Pre-formatted documents not found: $PREFMTDOCSTAR.gz"
            echo ""
            echo "Configuration will continue..."
            echo ""
            sleep 3
            # exit 8

        else
            chmod 0444 $PREFMTDOCSTAR.gz

          echo "$PGMNAME:  Removing previous documentation installation"
            if test -d doc/.; then chmod -R +w doc; fi
            if test -d doc.ORIG/.; then chmod -R +w doc.ORIG; fi

            rm -rf doc doc.ORIG
            if test -d doc/.
            then
              echo "$PGMNAME:  Could not remove directory '$PGMDIR/doc'"
                exit 9
            fi
            if test -d doc.ORIG/.
            then
         echo "$PGMNAME:  Could not remove directory '$PGMDIR/doc.ORIG'"
                exit 10
            fi

            echo "$PGMNAME:  Installing pre-formatted documentation"
            cat $PREFMTDOCSTAR.gz | gunzip | tar xf - doc 

            echo "$PGMNAME:  Verifying documentation install"
            if test 0 -ne $?
            then
     echo "$PGMNAME:  Cannot perform tar extract from $PREFMTDOCSTAR.gz"
                exit 11
            fi
            if test ! -d doc/.
            then
                echo "$PGMNAME:  Cannot create '$PGMDIR/doc' directory"
                exit 12
            fi

      echo "$PGMNAME:  Moving pre-formatted documentation to 'doc.ORIG'"
            mv doc doc.ORIG
            chmod -R -w doc.ORIG

            if test ! -d doc.ORIG/.
            then
            echo "$PGMNAME:  Cannot create '$PGMDIR/doc.ORIG' directory"
                exit 13
            fi
        fi
        ;;

    *)  ;;
esac

###################################################################
#
# Run phase 3:  C Compilation and Document Compilation Setup
#
# (Phase 2 did setup and run all above.)
#
rm -rf config
if test -d config/.
then
    echo "$PGMNAME:  Could not remove directory '$PGMDIR/config'"
    exit 14
fi

mkdir config
if test ! -d config
then
    echo "$PGMNAME:  Cannot create '$PGMDIR/config' directory"
    exit 15
fi

CRME="config/README"
THISDATE=`date`
(
    echo ""
    echo "Boot JVM build configuration files."
    echo ""
    echo "Auto-generated by $PGMNAME"
    echo "on $THISDATE:"
    echo "DO NOT MODIFY!"
    echo ""
    echo "Instead, run $PGMNAME to change anything."
    echo "(The same goes for the '*.gcc' and '*.gccld' files in"
    echo "this directory, but they cannot contain any comments.)"
    echo ""

) > $CRME

chmod -w $CRME

(
    # Include basic doxygen tokens for documentation purposes
    echo "/*!"
    echo " * @file config.h"
    echo " *"
    echo " * @brief Boot JVM build configuration."
    echo " *"
    echo " * Top-level configuration declarations."
 echo " * Auto-generated by @link ./config.sh $PGMNAME@endlink"
    echo " * on $THISDATE:"
    echo " * <b>@verbatim"
    echo ""
    echo "   DO NOT MODIFY!"
    echo ""
    echo "   @endverbatim</b>"
    echo " *"
    echo " * @section Control"
    echo " *"
    echo " * Id:  Auto-generated by @c @b $PGMNAME"
    echo " *"
    echo " * Copyright `date +%Y` The Apache Software Foundation"
    echo " * or its licensors, as applicable."
    echo " *"
echo " * Licensed under the Apache License, Version 2.0 (\"the License\");"
echo " * you may not use this file except in compliance with the License."
    echo " * You may obtain a copy of the License at"
    echo " *"
    echo " *     http://www.apache.org/licenses/LICENSE-2.0"
    echo " *"
    echo " * Unless required by applicable law or agreed to in writing,"
   echo " * software distributed under the License is distributed on an"
  echo " * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,"
    echo " * either express or implied."
    echo " *"
echo " * See the License for the specific language governing permissions"
    echo " * and limitations under the License."
    echo " *"
    echo " * @version N/A"
    echo " *"
    echo " * @date $THISDATE"
    echo " *"
    echo " * @author $USER"
    echo " *"
    echo " * @section Reference"
    echo " *"
    echo " */"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_PROGRAM_NAME"
    echo " * @brief Short project name string"
    echo " *"
    echo " * The program name string is used in both the source"
    echo " * and in the documentation title.  It is known between"
    echo " * this header and the Doxygen setup, where it is"
    echo " * called @c @b PROJECT_NAME in that parlance.  The"
    echo " * definition of @link #CONFIG_PROGRAM_DESCRIPTION"
    echo "   CONFIG_PROGRAM_DESCRIPTION@endlink is appended to"
    echo " * @c @b CONFIG_PROJECT_NAME to form the"
    echo " * text 'CONFIG_PROGRAM_NAME: CONFIG_PROGRAM_DESCRIPTION'"
    echo " * in that location."
    echo " *"
    echo " */"
    echo "#define CONFIG_PROGRAM_NAME \"$PROGRAM_NAME\""

    echo ""
    echo "/*!"
    echo " * @def CONFIG_PROGRAM_DESCRIPTION"
    echo " * @brief Short description string of project function"
    echo " *"
    echo " * The program description is a short string describing"
    echo " * the functionality of the program.  It is known commonly"
    echo " * between this header and the Doxygen setup, where it is"
    echo " * called @c @b PROJECT_NAME in that parlance.  The"
    echo " * definition of @c @b CONFIG_PROGRAM_DESCRIPTION is appended"
    echo " * to @link #CONFIG_PROGRAM_NAME CONFIG_PROGRAM_NAME@endlink"
    echo " * to form the"
    echo " * text 'CONFIG_PROGRAM_NAME: CONFIG_PROGRAM_DESCRIPTION'"
    echo " * in that location."
    echo " *"
    echo " */"
    echo "#define CONFIG_PROGRAM_DESCRIPTION \"$PROGRAM_DESCRIPTION\""

    echo ""
    echo "/*!"
    echo " * @def CONFIG_RELEASE_LEVEL"
    echo " * @brief Project release as major, minor, and patchlevel"
    echo " *"
    echo " * The release number is stored in a three-field tuple"
    echo " * as 'major.minor.patchlevel'.  It is known commonly"
    echo " * between this header and the Doxygen setup, where it"
    echo " * is called @c @b PROJECT_NUMBER in that parlance."
    echo " *"
    echo " */"
    echo "#define CONFIG_RELEASE_LEVEL \"$RELEASE_LEVEL\""

    echo ""
    echo "/*!"
    echo " * @def CONFIG_WORDWIDTH$WORDWIDTH"
    echo " * @brief Number of bits in real machine integer word."
    echo " *"
    echo " * This value may be either @b 32 or @b 64."
    echo " *"
    echo " */"
    echo "#define CONFIG_WORDWIDTH$WORDWIDTH"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_$HWVENDOR"
    echo " * @brief Manufacturer or type of CPU."
    echo " *"
    echo " * This value typically implys a specific CPU architecture"
    echo " * rather than a manufacturer of a number of them."
    echo " *"
    echo " * @b sparc means Sun's SPARC CPU architecture."
    echo " *"
    echo " * @b intel means Intel's x86 CPU architecture."
    echo " *"
    echo " */"
    echo "#define CONFIG_$HWVENDOR"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_$HWVENDOR$WORDWIDTH"
    echo \
" * @brief Combination of CONFIG_$HWVENDOR and CONFIG_WORDWIDTH$WORDWIDTH."
    echo " *"
    echo " */"
    echo "#define CONFIG_$HWVENDOR$WORDWIDTH"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_$OSNAME"
    echo " * @brief Operating system name."
    echo " *"
    echo " * This value may be @b solaris or @b linux or @b windows."
    echo " *"
    OSTXTABBRV="Unix architecture operating system" # Keep short lines
    echo " * @b solaris means Sun's premier $OSTXTABBRV"
    echo " *"
    echo " * @b linix means the open-source $OSTXTABBRV"
    echo " *"
    echo " * @b windows means Microsoft's proprietary operating system."
    echo " *"
    echo " * Notice that, with the exception of @b windows, various CPU"
    echo " * architectures may run various operating systems."
    echo " *"
    echo " */"
    echo "#define CONFIG_$OSNAME"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_$OSNAME$WORDWIDTH"
    echo \
" * @brief Combination of CONFIG_$OSNAME and CONFIG_WORDWIDTH$WORDWIDTH."
    echo " *"
    echo " */"
    echo "#define CONFIG_$OSNAME$WORDWIDTH"

    echo ""
    echo "/*!"
    echo " * @def CONFIG_HACKED_RTJARFILE"
    echo " * @brief Location of run-time Java class library archive."
    echo " *"
    echo " * This JAR file name may be appended to @b BOOTCLASSPATH"
    echo " * as a development hack to provide a default startup class"
    echo " * library until the project has something better.  This"
    echo " * file name points to the JRE run-time class library archive"
    echo " * file name as requested from user input by" 
    echo " * @c @b $PGMNAME at configuration time."
    echo " *"
    echo " * This symbol may be removed via @c @b \#undef in"
    echo \
" * @link jvm/src/jvmcfg.h jvmcfg.h @endlink if desired without"
    echo " * changing its definition here in this file."
    echo " *"
    echo " * @todo  Put fuller definition for this symbol and its" 
    echo " *        usage into the code in"
    echo " *        @link jvm/src/classpath.c classpath.c @endlink."
    echo " *"
    echo " * @todo  Need to find some other way to locate the class"
    echo " *        library archive in the JDK so that @e any JDK may"
    echo " *        be considered (initially).  Need to ultimately"
    echo " *        change out the logic that uses it over time to"
    echo " *        begin looking for natively constructed class"
    echo " *        library archive instead of leaning on outside work."
    echo " *"
    echo " */"
    echo "#define CONFIG_HACKED_RTJARFILE \"$RTJARFILE\""

    echo ""
    echo "/*!"
    echo " * @def CONFIG_HACKED_BOOTCLASSPATH"
    echo \
      " * @brief Location of provisional run-time Java startup classes."
    echo " *"
    echo " * Internally append this name onto the end of @b CLASSPATH"
    echo " * as a development hack to provide a default startup class"
    echo " * library until the project has something better.  This"
    echo " * directory name points to the @b bootclasspath directory"
    echo " * as created by @c @b $PGMNAME at configuration time."
    echo " *"
    echo " * This symbol may be removed via @c @b \#undef in"
    echo \
" * @link jvm/src/jvmcfg.h jvmcfg.h @endlink if desired without"
    echo " * changing its definition here in this file."
    echo " *"
    echo " * @todo  Put fuller definition for this symbol and its" 
    echo " *        usage into the code in"
    echo " *        @link jvm/src/classpath.c classpath.c @endlink"
    echo " *        and @link jvm/src/argv.c argv.c @endlink."
    echo " *"
    echo " * @todo  Remove compiled absolute path name in favor or"
    echo " *        either a relative path name or removal of this"
    echo " *        symbol from the logic entirely."
    echo " *"
    echo " */"
    echo "#define CONFIG_HACKED_BOOTCLASSPATH \"$PGMDIR/bootclasspath\""
    echo ""

  if test -z "$HEAPALLOC"
  then
    echo ""
    echo "/*!"
    echo " * @internal There is no heap allocation method configured"
    echo " *"
    echo " */"
  else
    echo ""
    echo "/*!"
    echo " * @def CONFIG_$HEAPALLOC"
    echo " * @brief Heap allocation method"
    echo " *"
    echo " * This value may be @b simple or @b bimodal or @b other."
    echo " *"
    echo " * @b simple means @c @b malloc(3)/free(3) only"
    echo " *"
  echo " * @b bimodal means @c @b malloc(3)/free(3) plus a large buffer"
    echo " *"
    echo " * @b other means roll your own-- generates unresolved"
    echo " *          external symbols."
    echo " *"
    echo " * Refer to"
    echo " * @link jvm/src/heap_bimodal.c heap_bimodal.c@endlink"
    echo " * for a good example as to how to implement the heap API and"
    echo " * incorporate it into the suite of heap allocation options."
    echo " * Remember also to add it to"
    echo " * @link ./$PGMNAME $PGMNAME@endlink"
    echo " * so others may configure and use it."
    echo " *"
    echo " */"
    echo "#define CONFIG_$HEAPALLOC"
  fi

  if test -z "$GCMETHOD"
  then
    echo ""
    echo "/*!"
    echo " * @internal There is no garbage collection method configured"
    echo " *"
    echo " */"
  else
    echo ""
    echo "/*!"
    echo " * @def CONFIG_$GCMETHOD"
    echo " * @brief Garbage collection method"
    echo " *"
    echo " * This value may be @b stub or @b other."
    echo " *"
    echo " * @b stub means API only, no content"
    echo " *"
    echo " * @b other means roll your own-- generates unresolved"
    echo " *          external symbols."
    echo " *"
    echo " * Refer to"
    echo " * @link jvm/src/heap_bimodal.c heap_bimodal.c@endlink"
    echo " * for a good example as to how to implement the heap API and"
    echo " * incorporate it into the suite of heap allocation options."
    echo " * The garbage collection API is similarly implemented."
    echo " * Remember also to add it to"
    echo " * @link ./$PGMNAME $PGMNAME@endlink"
    echo " * so others may configure and use it."
    echo " *"
    echo " */"
    echo "#define CONFIG_$GCMETHOD"
  fi

    echo "/* EOF */"

) > $CFGH

chmod -w $CFGH


# Always pack structures, support static copyright info strings
INCLUDE_PATHS="\
  -Iinclude \
  -I$PGMDIR/config \
  -I$PGMDIR/jvm/include \
  -I$JAVA_HOME/include \
  -I$JAVA_HOME/include/$osname"

CONSTANT_GCC_OPTIONS="-O0 -g3 -Wall -fmessage-length=0 -ansi"

ALWAYS_REQUIRED_GCC_OPTIONS="\
  -m$WORDWIDTH \
  $INCLUDE_PATHS \
  $CONSTANT_GCC_OPTIONS"

ALWAYS_REQUIRED_GCCLD_OPTIONS="-m$WORDWIDTH -lpthread"

USUALLY_REQUIRED_GCC_OPTIONS="-fpack-struct"

COAG="config/config_opts_always.gcc"
(
    echo "$ALWAYS_REQUIRED_GCC_OPTIONS"

) > $COAG

chmod -w $COAG

COUG="config/config_opts_usually.gcc"
(
    echo "$USUALLY_REQUIRED_GCC_OPTIONS"

) > $COUG

chmod -w $COUG

LOAG="config/config_opts_always.gccld"
(
    echo "$ALWAYS_REQUIRED_GCCLD_OPTIONS"

) > $LOAG

chmod -w $LOAG

USEDOX="for use by 'dox.sh'"
USEDOXBLD="for use by 'dox.sh' and 'build.sh'"
USEBLDCLN="for use by 'build.sh' and 'clean.sh'"

CRCD="config/config_roster_c.dox"
(
    echo "#"
    echo "# Roster of source files $USEDOXBLD"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT=\\"
    for f in `ls -1 jvm/src/*.c`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CRCD

chmod -w $CRCD

CRHD="config/config_roster_h.dox"
(
    echo "#"
    echo "# Roster of header files $USEDOX"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    echo "    config/config.h \\"
    for f in main/src/main.c `ls -1 jvm/src/*.h`
    do
        echo "    $f \\"
    done

    for f in `ls -1 jvm/include/*.h`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CRHD

chmod -w $CRHD

CJCD="config/config_roster_jni_c.dox"
(
    echo "#"
    echo "# Roster of JNI sample C source files $USEDOXBLD"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    for f in `ls -1 jni/src/harmony/generic/0.0/src/*.c`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CJCD

chmod -w $CJCD

CJHD="config/config_roster_jni_h.dox"
(
    echo "#"
    echo "# Roster of JNI sample C header files $USEDOX"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    for f in `ls -1 jni/src/harmony/generic/0.0/include/*.h`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CJHD

chmod -w $CJHD

CJJD="config/config_roster_jni_java.dox"
(
    echo "#"
    echo "# Roster of JNI sample Java source files $USEDOXBLD"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    for f in \
        `find jni/src/harmony/generic/0.0/src -name \*.java -print`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CJJD

chmod -w $CJJD

CTJD="config/config_roster_test_java.dox"
(
    echo "#"
    echo "# Roster of test Java source files $USEDOXBLD"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    for f in \
        `find test/src -name \*.java -print`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CTJD

chmod -w $CTJD

CUSD="config/config_roster_sh.dox"
(
    echo "#"
    echo "# Roster of shell scripts $USEDOX"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "INPUT+=\\"
    # Have ./*.sh listed _LAST_ due to Doxygen bug that points
    # reference to them off to last `basename X` in list.
    # Unfortunately, this bug also produces blank documentation,
    # but at least the annotations are present and point to the
    # right page. The bug has something to do with multiple files
    # named 'build.sh' et al and having one of these in the top-level
    # directory.  It wants more path name clarification, but does
    # not seem to like even absolute path names.  The other scripts
    # in the top-level directory are properly parsed.
    #
    # Notice that 'jvm/*.sh' have the relative path prefix './' attached
    # to the front of the @@file directive.  This is to avoid an
    # interesting sensitivity in Doxygen that got confused between
    # 'jvm/filename.sh' and 'libjvm/filename.sh' and failed to produce
    # the "File List" entry for the 'jvm/*.sh' files in question,
    # namely its build scripts.  By marking them './jvm/build.sh' et al,
    # this behavior went away.  This same comment may be found in each
    # of those scripts.
    #
    # Even with them listed last, the '@ f i l e' directive still
    # must have an absolute path name for the documentation to
    # be properly parsed.
    #
    for f in `ls -1 */build.sh */clean.sh */common.sh; \
              ls -1 jni/src/*/*/*/build.sh; \
              ls -1 jni/src/*/*/*/clean.sh; \
              ls -1 jni/src/*/*/*/common.sh; \
              ls -1 $PGMDIR/[ILR]*; \
              ls -1 $PGMDIR/*.sh`
    do
        echo "    $f \\"
    done
    echo ""
    echo "# EOF"

) > $CUSD

chmod -w $CUSD

CBSD="config/config_build_steps.sh"
(
    echo "#"
    echo "# Code build steps configured by user $USEBLDCLN"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "CONFIG_RELEASE_LEVEL=\"$RELEASE_LEVEL\""
    echo "export CONFIG_RELEASE_LEVEL"
    echo "CONFIG_BUILD_ALLCODE=$BUILD_ALLCODE"
    echo "CONFIG_BUILD_JVM=$BUILD_JVM"
    echo "CONFIG_BUILD_LIB=$BUILD_LIB"
    echo "CONFIG_BUILD_MAIN=$BUILD_MAIN"
    echo "CONFIG_BUILD_TEST=$BUILD_TEST"
    echo "CONFIG_BUILD_JNI=$BUILD_JNI"
    echo "CONFIG_BUILD_DOX=$BUILD_DOX"
 echo "CONFIG_BUILD_HTML_ADJUST_NETSCAPE47X=$BUILD_HTML_ADJ_NETSCAPE47X"
    echo ""
    echo "# EOF"

) > $CBSD

chmod -w $CBSD

CDSD="config/config_dox_setup.dox"
(
    echo "#"
    echo "# documentation build steps configured by user $USEDOX"
    echo "#"
    echo "# Auto-generated by $PGMNAME"
    echo "# on $THISDATE:"
    echo "# DO NOT MODIFY!"
    echo "#"
    echo "PROJECT_NAME=\"$PROGRAM_NAME: $PROGRAM_DESCRIPTION\""
    echo "PROJECT_NUMBER=\"$RELEASE_LEVEL\""
    echo "GENERATE_HTML=$BUILD_HTML"
    echo "GENERATE_LATEX=$BUILD_LATEX"
    echo "GENERATE_RTF=$BUILD_RTF"
    echo "GENERATE_MAN=$BUILD_MAN"
    echo "GENERATE_XML=$BUILD_XML"
    echo ""
    echo "# EOF"

) > $CDSD

chmod -w $CDSD

#############################
#
# END set up 'config' directory.
#

###################################################################
#
# Run phase 4: Extract startup classes for system bootstrap
#
if test 1 -eq $dosetupboot
then

    ###
    echo "$PGMNAME:  Setting up boot class library class area..."

    rm -rf bootclasspath
    if test -d bootclasspath
    then
    echo "$PGMNAME:  Could not remove directory '$PGMDIR/bootclasspath'"
        exit 16
    fi

    mkdir bootclasspath
    if test ! -d bootclasspath
    then
       echo "$PGMNAME:  Cannot create '$PGMDIR/bootclasspath' directory"
        exit 17
    fi

    echo ""
    echo "$PGMNAME:  Extracting classes for $PGMDIR/bootclasspath"
    ###

    # Normally ('true') just extract those that are always referenced
    # at startup, but if desired ('false'), extract a whole list of
    # useful and interesting classes, especially those that are
    # used during JVM initialization.
    if test 0 -eq $biglib
    then
        JAVA_LANG_CLASS_LIST="Object Class String Thread"
        JAVA_LANG_REF_CLASS_LIST=""
        JAVA_LANG_REFLECT_CLASS_LIST=""
        JAVA_UTIL_JAR_CLASS_LIST=""
        JAVA_UTIL_ZIP_CLASS_LIST=""
        JAVA_IO_CLASS_LIST=""
    else
        JAVA_LANG_CLASS_LIST="Object Class String Thread \
\
        ThreadGroup Void Runtime System \
\
        SecurityManager ClassLoader \
\
        Throwable StackTraceElement \
\
        Exception \
        ClassNotFoundException \
        CloneNotSupportedException \
\
        RuntimeException \
        ArithmeticException \
        ArrayIndexOutOfBoundsException \
        ArrayNegativeSizeException \
        ArrayStoreSizeException \
        IllegalArgumentException \
        IllegalMonitorStateException \
        IllegalThreadStateException \
        InterruptedException \
        IndexOutOfBoundsException \
        IndexOutOfBoundsException \
        NullPointerException \
        SecurityException \
\
        Error \
        ClassFormatError \
        ClassCircularityError \
        ExceptionInitializationError \
        IllegalAccessError \
        IncompatibleClassChangeError \
        InstantiationError \
        InternalError \
        LinkageError \
        NoClassDefFoundError \
        NoSuchFieldError \
        NoSuchMethodError \
        OutOfMemoryError \
        StackOverflowError \
        UnknownError \
        UnsatisfiedLinkError \
        UnsupportedClassVersionError \
        VerifyError \
        VirtualMachineError"

        JAVA_LANG_REF_CLASS_LIST="Finalizer"

        JAVA_LANG_REFLECT_CLASS_LIST="Array Constructor Method Field"

        JAVA_UTIL_JAR_CLASS_LIST="JarFile JarEntry Manifest"

        JAVA_UTIL_ZIP_CLASS_LIST="ZipFile ZipEntry"

        JAVA_IO_CLASS_LIST="InputStream IOException \
        FileNotFoundException \
\
        OutputStream FilterOutputStream PrintStream \
\
        Serializable"
    fi

    cd bootclasspath
    rc=0
    if test -n "$JAVA_LANG_CLASS_LIST"
    then
        for class in $JAVA_LANG_CLASS_LIST
        do
            echo "java.lang.$class"
            $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                  java/lang/$class.class

            if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test -n "$JAVA_LANG_REFCLASS_LIST"
    then
        for class in $JAVA_LANG_REF_CLASS_LIST
        do
            echo "java.lang.ref.$class"
            $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                  java/lang/ref/$class.class

            if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test -n "$JAVA_LANG_REFLECT_CLASS_LIST"
    then
        for class in $JAVA_LANG_REFLECT_CLASS_LIST
        do
            echo "java.lang.reflect.$class"
            $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                  java/lang/reflect/$class.class

            if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test -n "$JAVA_UTIL_JAR_CLASS_LIST"
    then
        for class in $JAVA_UTIL_JAR_CLASS_LIST
        do
            echo "java.util.jar.$class"
            $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                  java/util/jar/$class.class
    
        if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test -n "$JAVA_UTIL_ZIP_CLASS_LIST"
    then
        for class in $JAVA_UTIL_ZIP_CLASS_LIST
        do
            echo "java.util.zip.$class"
                $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                   java/util/zip/$class.class

            if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test -n "$JAVA_IO_CLASS_LIST"
    then
        for class in $JAVA_IO_CLASS_LIST
        do
            echo "java.io.$class"
            $JAVA_HOME/bin/jar xf $CONFIG_RTJARFILE \
                                   java/io/$class.class

            if test 0 -ne $rc
            then
                rc=1
            fi
        done
    fi
    if test 0 -ne $rc
    then
        echo "$PGMNAME:  Could not extract all startup library classes"
        exit 18
    fi

    cd ..

fi

#############################
#
# END set up 'bootclasspath' directory.  Now report config results:
#
(
    BLDS="build.sh ... in selected locations"
    CLNS="clean.sh ... in selected locations"
    CMNS="common.sh ... in selected locations"

    echo ""

    # Change to 'if true' if auto-generated file result printout desired
    if false
    then
        echo "Auto-generated compile header definitions:"
        echo ""
        echo "---"
        cat $CFGH
        echo "---"
        echo ""
        echo "Auto-generated compiler invocation options:"
        echo "    "
        echo "--- GCC options always required:"
        cat $COAG
        echo "--- GCC options usually required:"
        cat $COUG
        echo "--- GCC linker options always required:"
        cat $LOAG
        echo "--- Source files:"
        cat $CRCD
        echo "--- Header files"
        cat $CRHD
        echo "--- JNI sample C source files:"
        cat $CJCD
        echo "--- JNI sample C header files:"
        cat $CJHD
        echo "--- JNI sample Java source files:"
        cat $CJJD
        echo "--- Test Java source files:"
        cat $CTJD
        echo "--- utility shell scripts"
        cat $CUSD
        echo "--- code build steps"
        cat $CBSD
        echo "--- documentation build steps"
        cat $CDSD
        echo "--- project build steps"
    else
        echo "$PGMNAME:  Compile configuration:         $CFGH"
        echo "$PGMNAME:  GCC options always used:       $COAG"
        echo "$PGMNAME:  GCC options usually used:      $COUG"
        echo "$PGMNAME:  GCC linker opts (always):      $LOAG"
        echo "$PGMNAME:  Source files:                  $CRCD"
        echo "$PGMNAME:  Header files:                  $CRHD"
        echo "$PGMNAME:  Sample JNI C source files:     $CJCD"
        echo "$PGMNAME:  Sample JNI C header files:     $CJHD"
        echo "$PGMNAME:  Sample JNI Java source files:  $CJJD"
        echo "$PGMNAME:  Test Java source files:        $CTJD"
        echo "$PGMNAME:  Utility shell scripts:         $CUSD"
        echo "$PGMNAME:  Code build steps:              $CBSD"
        echo "$PGMNAME:  Documentation build steps:     $CDSD"
    fi

    echo "$PGMNAME:  Build scripts:                 $BLDS"
    echo "$PGMNAME:  Clean build scripts:           $CLNS"
    echo "$PGMNAME:  Common build scripts:          $CMNS"
    echo ""
) | more


echo ""
$echon "$PGMNAME: Starting to build... $echoc"
sleep 3
echo ""
echo ""

###################################################################
#
# Run phase 5:  Build binary from source code
#
echo  ""
echo  "$PGMNAME:  Building configured components"
echo ""
echo "$PGMNAME:  Cleaning out entire tree of anything left over"
echo ""
./clean.sh all
rc=$?


case $buildnow in
    y|ye|yes|Y|YE|YES)
        echo ""
        echo "$PGMNAME:  Building configured components"
        echo ""
        ./build.sh cfg
        rc=$?
        ;;
    *)  ;;
esac

###################################################################
#
# Done.  Return with exit code from build script.
#
echo ""
echo "$PGMNAME:  Return from build with exit code $rc"
echo ""

exit $rc
#
# EOF
