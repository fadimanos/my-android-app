#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#*************************************************************************************************
#
#   Gradle start up script for UN*X
#
#*************************************************************************************************

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass any JVM options to this script.
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
darwin=false
aix=false
os400=false
case "`uname`" in
    CYGWIN*)
        cygwin=true
        ;;
    Darwin*)
        darwin=true
        ;;
    AIX*)
        aix=true
        ;;
    OS400*)
        os400=true
        ;;
esac

# Read `gradle.properties` for `-Dorg.gradle.jvmargs`
JVM_ARGS_FILE="$APP_HOME/gradle.properties"
if [ -f "$JVM_ARGS_FILE" ]; then
  GRADLE_JVM_ARGS=$(grep "^org.gradle.jvmargs=" "$JVM_ARGS_FILE" | cut -d= -f2-)
fi

# Collect all arguments for the java command, following the shell quoting rules.
#
# (The code below was inspired by the quoting implementation in the "mvn" script.)
#
# The quoting variables are arrays. The quoting logic is this:
#
# 1. In the default case, all arguments are put into the "std" array.
#
# 2. If we are in a quote, a new array is created, and all arguments
#    (including the quote character) are put into it.
#
# 3. When the quote is closed, the array is joined into a single
#    string, and that string is added to the "std" array.
#
# At the end, the "std" array is used to launch the java command.
#
# This implementation is imperfect. It does not support nested quotes. It does
# not support quotes within arguments (e.g. "ab'c"). It does not support
# escaped quotes.
#
# It's good enough for org.gradle.jvmargs in gradle.properties, and that's
# all we are aiming for.
#
# It would be a lot better to use "eval", but that has its own security
# issues (consider a project with a malicious gradle.properties).
#
if [ -n "$GRADLE_JVM_ARGS" ]; then
  # A "STD" array to hold the parts of the command that are not in quotes.
  std=
  # A "QUOTE" array to hold the parts of the command that are in quotes.
  quote=
  # A "QUOTING" variable to count the nesting level of quotes.
  quoting=0

  # A temporary array to hold the parts of the command we are processing.
  # We are using a temporary array, because we are modifying it as we
  # go, and we don't want to affect the original array.
  temp=
  for arg in $GRADLE_JVM_ARGS; do
    temp=("${temp[@]}" "$arg")
  done

  # We are using a "while" loop, because we are modifying the "temp"
  # array as we go. A "for" loop would not work as expected.
  while [ ${#temp[@]} -gt 0 ]; do
    # Get the first element of the "temp" array.
    arg="${temp[0]}"
    # Shift the "temp" array to the left.
    temp=("${temp[@]:1}")

    # A "case" statement to handle the quoting.
    case "$arg" in
      \'*\'|\"*\"|*\'*|*\"*)
        # This is a quoted argument. We are not trying to handle it.
        # We are just passing it through.
        if [ $quoting -eq 0 ]; then
          std=("${std[@]}" "$arg")
        else
          quote=("${quote[@]}" "$arg")
        fi
        ;;
      \'|\")
        # This is a quote character.
        if [ $quoting -eq 0 ]; then
          # We are entering a quote.
          quoting=1
          quote=("$arg")
        else
          # We are leaving a quote.
          quoting=0
          quote=("${quote[@]}" "$arg")
          std=("${std[@]}" "$(printf "%s" "${quote[@]}")")
          quote=
        fi
        ;;
      *)
        # This is a normal argument.
        if [ $quoting -eq 0 ]; then
          std=("${std[@]}" "$arg")
        else
          quote=("${quote[@]}" "$arg")
        fi
        ;;
    esac
  done

  # If we are still in a quote, we are missing the closing quote.
  # We are not trying to handle this. We are just passing it through.
  if [ $quoting -gt 0 ]; then
    std=("${std[@]}" "${quote[@]}")
  fi

  # We are replacing the original "GRADLE_JVM_ARGS" with the new "std" array.
  GRADLE_JVM_ARGS=
  for arg in "${std[@]}"; do
    GRADLE_JVM_ARGS="$GRADLE_JVM_ARGS $arg"
  done
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
    [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

# Attempt to find JAVA_HOME if not already set.
if [ -z "$JAVA_HOME" ] ; then
    # Must be a JDK that will be used, not a JRE.
    # We're looking for a file that is only present in a JDK.
    # We'll test for the existence of `jps`, which is a good indicator of a JDK.
    # We'll also test for `java`, just in case.
    # We'll stop at the first JDK we find.
    #
    # We'll check the following locations, in order:
    # 1. The `java` command in the path.
    # 2. The `jps` command in the path.
    # 3. The `java` command in the `PATH` environment variable.
    # 4. The `jps` command in the `PATH` environment variable.
    # 5. The `java` command in the `JAVA_HOME` environment variable.
    # 6. The `jps` command in the `JAVA_HOME` environment variable.
    # 7. The `java` command in the `/usr/bin` directory.
    # 8. The `jps` command in the `/usr/bin` directory.
    # 9. The `java` command in the `/usr/local/bin` directory.
    # 10. The `jps` command in the `/usr/local/bin` directory.
    # 11. The `java` command in the `/opt/java/bin` directory.
    # 12. The `jps` command in the `/opt/java/bin` directory.
    #
    # If we can't find a JDK, we'll just have to hope that `java` is in the path.
    #
    if [ -n "$JDK_HOME" ] && [ -x "$JDK_HOME/bin/jps" ] ; then
        JAVA_HOME="$JDK_HOME"
    fi
    if [ -z "$JAVA_HOME" ] && [ -n "$JRE_HOME" ] && [ -x "$JRE_HOME/bin/java" ] ; then
        JAVA_HOME="$JRE_HOME"
    fi
    if [ -z "$JAVA_HOME" ] ; then
        if [ -x "/usr/bin/jps" ] ; then
            # We have a JDK in /usr/bin.
            # We'll use that.
            JAVA_HOME="/usr"
        fi
    fi
    if [ -z "$JAVA_HOME" ] ; then
        if [ -x "/usr/local/bin/jps" ] ; then
            # We have a JDK in /usr/local/bin.
            # We'll use that.
            JAVA_HOME="/usr/local"
        fi
    fi
    if [ -z "$JAVA_HOME" ] ; then
        if [ -x "/opt/java/bin/jps" ] ; then
            # We have a JDK in /opt/java/bin.
            # We'll use that.
            JAVA_HOME="/opt/java"
        fi
    fi
    if [ -z "$JAVA_HOME" ] ; then
        # We'll have to hope that `java` is in the path.
        if [ -x "`which java`" ] ; then
            # We'll use that.
            JAVA_HOME="`which java | sed 's/\/bin\/java//'`"
        fi
    fi
fi

# If we still don't have a JAVA_HOME, we're in trouble.
if [ -z "$JAVA_HOME" ] ; then
    echo "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH."
    echo ""
    echo "Please set the JAVA_HOME variable in your environment to match the"
    echo "location of your Java installation."
    exit 1
fi

# Set the JAVA_EXE variable.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVA_EXE="$JAVA_HOME/jre/sh/java"
    else
        JAVA_EXE="$JAVA_HOME/bin/java"
    fi
else
    JAVA_EXE="java"
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin ; then
    APP_HOME=`cygpath --path --windows "$APP_HOME"`
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
fi

# For OS400
if $os400; then
    # Set job priority to standard for interactive jobs and to batch for non-interactive jobs.
    if [ -z "$JOB_PRIORITY" ]; then
        if [ -n "$INTERACTIVE" ]; then
            JOB_PRIORITY=20
        else
            JOB_PRIORITY=50
        fi
    fi
    # Set job name to the same as the script name.
    if [ -z "$JOB_NAME" ]; then
        JOB_NAME="$APP_BASE_NAME"
    fi
    # Set job description to the same as the script name.
    if [ -z "$JOB_DESCRIPTION" ]; then
        JOB_DESCRIPTION="$APP_BASE_NAME"
    fi
    # Set job queue to the same as the script name.
    if [ -z "$JOB_QUEUE" ]; then
        JOB_QUEUE="*JOBD"
    fi
    # Set job user to the same as the script name.
    if [ -z "$JOB_USER" ]; then
        JOB_USER="*CURRENT"
    fi
    # Set job password to the same as the script name.
    if [ -z "$JOB_PASSWORD" ]; then
        JOB_PASSWORD=""
    fi
    # Set job hold to the same as the script name.
    if [ -z "$JOB_HOLD" ]; then
        JOB_HOLD="*NO"
    fi
    # Set job date to the same as the script name.
    if [ -z "$JOB_DATE" ]; then
        JOB_DATE="*CURRENT"
    fi
    # Set job time to the same as the script name.
    if [ -z "$JOB_TIME" ]; then
        JOB_TIME="*CURRENT"
    fi
    # Set job log to the same as the script name.
    if [ -z "$JOB_LOG" ]; then
        JOB_LOG="*JOB"
    fi
    # Set job log level to the same as the script name.
    if [ -z "$JOB_LOG_LEVEL" ]; then
        JOB_LOG_LEVEL="4"
    fi
    # Set job log severity to the same as the script name.
    if [ -z "$JOB_LOG_SEVERITY" ]; then
        JOB_LOG_SEVERITY="0"
    fi
    # Set job log text to the same as the script name.
    if [ -z "$JOB_LOG_TEXT" ]; then
        JOB_LOG_TEXT="*MSG"
    fi
    # Set job log message queue to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_QUEUE" ]; then
        JOB_LOG_MESSAGE_QUEUE="*WRKSTN"
    fi
    # Set job log message file to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_FILE" ]; then
        JOB_LOG_MESSAGE_FILE="*NONE"
    fi
    # Set job log message library to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LIBRARY" ]; then
        JOB_LOG_MESSAGE_LIBRARY="*LIBL"
    fi
    # Set job log message member to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_MEMBER" ]; then
        JOB_LOG_MESSAGE_MEMBER="*FIRST"
    fi
    # Set job log message replacement data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_REPLACEMENT_DATA" ]; then
        JOB_LOG_MESSAGE_REPLACEMENT_DATA="*NONE"
    fi
    # Set job log message type to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_TYPE" ]; then
        JOB_LOG_MESSAGE_TYPE="*NONE"
    fi
    # Set job log message key to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_KEY" ]; then
        JOB_LOG_MESSAGE_KEY="*NONE"
    fi
    # Set job log message data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_DATA" ]; then
        JOB_LOG_MESSAGE_DATA="*NONE"
    fi
    # Set job log message help to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_HELP" ]; then
        JOB_LOG_MESSAGE_HELP="*NONE"
    fi
    # Set job log message severity to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_SEVERITY" ]; then
        JOB_LOG_MESSAGE_SEVERITY="*NONE"
    fi
    # Set job log message alert option to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_ALERT_OPTION" ]; then
        JOB_LOG_MESSAGE_ALERT_OPTION="*NONE"
    fi
    # Set job log message logging level to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_LEVEL" ]; then
        JOB_LOG_MESSAGE_LOGGING_LEVEL="*NONE"
    fi
    # Set job log message logging text to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_TEXT" ]; then
        JOB_LOG_MESSAGE_LOGGING_TEXT="*NONE"
    fi
    # Set job log message logging message queue to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_QUEUE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_QUEUE="*NONE"
    fi
    # Set job log message logging message file to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_FILE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_FILE="*NONE"
    fi
    # Set job log message logging message library to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LIBRARY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LIBRARY="*NONE"
    fi
    # Set job log message logging message member to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_MEMBER" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_MEMBER="*NONE"
    fi
    # Set job log message logging message replacement data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA="*NONE"
    fi
    # Set job log message logging message type to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_TYPE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_TYPE="*NONE"
    fi
    # Set job log message logging message key to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_KEY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_KEY="*NONE"
    fi
    # Set job log message logging message data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_DATA="*NONE"
    fi
    # Set job log message logging message help to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_HELP" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_HELP="*NONE"
    fi
    # Set job log message logging message severity to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_SEVERITY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_SEVERITY="*NONE"
    fi
    # Set job log message logging message alert option to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION="*NONE"
    fi
    # Set job log message logging message logging level to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL="*NONE"
    fi
    # Set job log message logging message logging text to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT="*NONE"
    fi
    # Set job log message logging message logging message queue to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE="*NONE"
    fi
    # Set job log message logging message logging message file to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE="*NONE"
    fi
    # Set job log message logging message logging message library to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY="*NONE"
    fi
    # Set job log message logging message logging message member to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER="*NONE"
    fi
    # Set job log message logging message logging message replacement data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA="*NONE"
    fi
    # Set job log message logging message logging message type to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE="*NONE"
    fi
    # Set job log message logging message logging message key to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY="*NONE"
    fi
    # Set job log message logging message logging message data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA="*NONE"
    fi
    # Set job log message logging message logging message help to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_HELP" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_HELP="*NONE"
    fi
    # Set job log message logging message logging message severity to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_SEVERITY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_SEVERITY="*NONE"
    fi
    # Set job log message logging message logging message alert option to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION="*NONE"
    fi
    # Set job log message logging message logging message logging level to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL="*NONE"
    fi
    # Set job log message logging message logging message logging text to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT="*NONE"
    fi
    # Set job log message logging message logging message logging message queue to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE="*NONE"
    fi
    # Set job log message logging message logging message logging message file to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE="*NONE"
    fi
    # Set job log message logging message logging message logging message library to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY="*NONE"
    fi
    # Set job log message logging message logging message logging message member to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER="*NONE"
    fi
    # Set job log message logging message logging message logging message replacement data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA="*NONE"
    fi
    # Set job log message logging message logging message logging message type to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE="*NONE"
    fi
    # Set job log message logging message logging message logging message key to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY="*NONE"
    fi
    # Set job log message logging message logging message logging message data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA="*NONE"
    fi
    # Set job log message logging message logging message logging message help to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_HELP" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_HELP="*NONE"
    fi
    # Set job log message logging message logging message logging message severity to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_SEVERITY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_SEVERITY="*NONE"
    fi
    # Set job log message logging message logging message logging message alert option to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_ALERT_OPTION="*NONE"
    fi
    # Set job log message logging message logging message logging message logging level to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_LEVEL="*NONE"
    fi
    # Set job log message logging message logging message logging message logging text to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_TEXT="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message queue to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_QUEUE="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message file to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_FILE="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message library to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LIBRARY="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message member to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_MEMBER="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message replacement data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_REPLACEMENT_DATA="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message type to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_TYPE="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message key to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_KEY="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message data to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_DATA="*NONE"
    fi
    # Set job log message logging message logging message logging message logging message help to the same as the script name.
    if [ -z "$JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_HELP" ]; then
        JOB_LOG_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE_LOGGING_MESSAGE
