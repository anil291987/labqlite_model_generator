#
# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# @author Jacob Barnard
#
# For more information, please refer to <http://unlicense.org>
#
# SCRIPT NAME:      labqlitemodelgen.sh
# SCRIPT VERSON:    1.0
SCRIPT_VERSION='labqlitemodelgen.sh 1.0'
CMPTBLE_LABQLITE_VRSN='LabQLite 1.0'
#
# This script creates an LabQLiteRow subclass 
# (.h and .m files) for each SQLite table and view.
#
# First parameter is the SQLite database file.
# Second parameter is the directory into which the .h and .m files
#    for the LabQLiteRow subclasses go.
#

#
# Affinities and the column data types for which
# they account.
#
TEXTUAL_AFFINITY_TYPE_SUBSTRINGS=( "CHAR" "CLOB" "TEXT" )
INTEGER_AFFINITY_TYPE_SUBSTRINGS=( "INT" )
REAL_AFFINITY_TYPE_SUBSTRINGS=( "REAL" "FLOA" "DOUB" )
NONE_AFFINITY_TYPE_SUBSTRINGS=( "BLOB" )
# NUMERIC if not matching one of the above.

SQLITE_DB_FILE_PATH="$1"
LABQLITEROW_SUBCLASSES_OUT_PATH="./$2"
LOG_FILE="$SQLITE_DB_FILE_PATH.log"
echo "$(tput setaf 4)"
echo "LabQLite iOS Model Class Generator 1.0"
echo "$(tput setaf 4)Model Generator>$(tput sgr0) SQLite database: $(tput setaf 3)$SQLITE_DB_FILE_PATH$(tput sgr0)"
echo "$(tput setaf 4)Model Generator>$(tput sgr0) Output directory: $(tput setaf 3)$LABQLITEROW_SUBCLASSES_OUT_PATH $(tput sgr0)"


# Create an array of table names
TABLE_NAMES=$(sqlite3 $SQLITE_DB_FILE_PATH <<EOF
.tables
.quit
EOF)

# TABLE_NAMES= `sqlite3` "$SQLITE_DB_FILE_PATH" <<EOF
# .tables >>$TABLE_NAMES
# .quit
# EOF

echo "$(tput setaf 4)Model Generator>$(tput sgr0) Found tables/views: $(tput setaf 3)$TABLE_NAMES$(tput sgr0)"

# Create an array of view names

# For each table t
mkdir "$LABQLITEROW_SUBCLASSES_OUT_PATH"
for TABLE_NAME in $TABLE_NAMES
do

    CAMEL_CASE_CLASS=""
    IFS='_' read -ra SUB_NAMES <<< "$TABLE_NAME"
    for i in "${SUB_NAMES[@]}"; do
        # process "$i"
        i="$(tr '[:lower:]' '[:upper:]' <<< ${i:0:1})${i:1}"
        CAMEL_CASE_CLASS="$CAMEL_CASE_CLASS$i"
    done

#   create new .h and .m files
    >"$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    >"$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    touch "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    touch "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"

#   prepend the beginnings of the .h file
    echo "$(tput setaf 4)Model Generator>$(tput sgr0) Processing $(tput setaf 3)$CAMEL_CASE_CLASS.h$(tput sgr0)..."
    echo "/*!" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h" 
    echo "    $CAMEL_CASE_CLASS : LabQLiteRow" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "    Generated using $SCRIPT_VERSION" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "    Compatible with $CMPTBLE_LABQLITE_VRSN" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo " */" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "#import <LabQLite/LaQLiteRow.h>" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "@interface $CAMEL_CASE_CLASS : LabQLiteRow" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"

#   prepend the beginnings of the .m file
    echo "/*!" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "    Implementation file for the $CAMEL_CASE_CLASS class." >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "    Generated using $SCRIPT_VERSION" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "    Compatible with $CMPTBLE_LABQLITE_VRSN" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo " */" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "#import \"$CAMEL_CASE_CLASS.h\"" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "@implementation $CAMEL_CASE_CLASS" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"

    echo "
#pragma mark - Required LabQLiteRowMappable @protocol Methods
    " >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"

    echo "- (NSString *)tableName {" "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "    return @\"$TABLE_NAME\";" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "}
    " >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "- (NSArray *)propertyKeysMatchingAttributeColumns {" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo -n "    return @[" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"

#   get the columns of t

PROPERTY_NAMES=()
COL_NAMES=()
AFFINITIES_FOR_CLASS=()
AFFINITY_PREFIX="SQLITE_AFFINITY_TYPE_"
NON_CAMEL_CASE_NAMES=()
COL_HEADERS=$(sqlite3 $SQLITE_DB_FILE_PATH <<EOF
pragma table_info($TABLE_NAME);
.quit
EOF)

    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"

    for LINE in $COL_HEADERS
    do
        IFS='|'
        COLS=($LINE)
        unset IFS
        for KEY in "${!COLS[@]}"
        do
            case "$KEY" in
            0)  COL_INDX="${COLS[$KEY]}"
                ;;
            1)  PROPERTY_NAME="${COLS[$KEY]}"
                COL_NAME="${COLS[$KEY]}"
                ;;
            2)  COL_TYPE="${COLS[$KEY]}"
                ;;
            3)  COL_NULLABLE="${COLS[$KEY]}"
                ;;
            4)  COL_DEFAULT_VAL="${COLS[$KEY]}"
                ;;
            5)  COL_IS_PK="${COLS[$KEY]}"
                ;;
            esac
        done
        if [ "$KEY" == "0" ]; then echo "@property (nonatomic)"
        fi 


        # Get the affinity based on the column

        # NUMERIC is default of the column declared type
        # does not contain one of the substrings needed
        # for another affinity type.
        AFFINITY="SQLITE_AFFINITY_TYPE_NUMERIC"
        TYPE="NSString *"

        for affinity_key in "${TEXTUAL_AFFINITY_TYPE_SUBSTRINGS[@]}";
        do
            if [[ "$COL_TYPE" == *"${affinity_key}"* ]]
            then
                AFFINITY="SQLITE_AFFINITY_TYPE_TEXT"
                TYPE="NSString *"
            fi
        done

        for affinity_key in "${INTEGER_AFFINITY_TYPE_SUBSTRINGS[@]}";
        do
            if [[ "$COL_TYPE" == *"${affinity_key}"* ]]
            then
                AFFINITY="SQLITE_AFFINITY_TYPE_INTEGER"
                TYPE="NSNumber *"
            fi
        done

        for affinity_key in "${REAL_AFFINITY_TYPE_SUBSTRINGS[@]}";
        do
            if [[ "$COL_TYPE" == *"${affinity_key}"* ]]
            then
                AFFINITY="SQLITE_AFFINITY_TYPE_REAL"
                TYPE="NSNumber *"
            fi
        done

        for affinity_key in "${NONE_AFFINITY_TYPE_SUBSTRINGS[@]}";
        do
            if [[ "$COL_TYPE" == *"${affinity_key}"* ]]
            then
                AFFINITY="SQLITE_AFFINITY_TYPE_NONE"
                TYPE="NSData *"
            fi
        done

        if [ $COL_IS_PK -eq 1 ]
            then NON_CAMEL_CASE_NAMES+=("$PROPERTY_NAME")
        fi

        CAMEL_CASE_NAME=""
        IFS='_' read -ra SUB_NAMES <<< "$PROPERTY_NAME"
        for i in "${SUB_NAMES[@]}"; do
            # process "$i"
            if [ "$CAMEL_CASE_NAME" != "" ]
                then i="$(tr '[:lower:]' '[:upper:]' <<< ${i:0:1})${i:1}"
            fi
            CAMEL_CASE_NAME="$CAMEL_CASE_NAME$i"
        done

        COL_NAMES+=("$COL_NAME")
        PROPERTY_NAMES+=("$CAMEL_CASE_NAME")
        AFFINITIES_FOR_CLASS+=("$AFFINITY")

        echo "/**" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
        echo " @note corresponding SQLite declared type is $COL_TYPE" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
        AFFINITY_BASE_STRING="${AFFINITY#$AFFINITY_PREFIX}"
        echo " @note corresponding SQLite affinity type is $AFFINITY_BASE_STRING" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
        echo "*/" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
        echo "@property (nonatomic) $TYPE$CAMEL_CASE_NAME;" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
        echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    done

    echo ""     >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"
    echo "@end" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.h"

    # add property names to the propertyKeysMatchingAttributeColumns
    # method within the .m file (these correspond to SQLite attributes)
    PROPERTY_NAMES_LENGTH=${#PROPERTY_NAMES[@]}
    for (( i = 0 ; i < ${#PROPERTY_NAMES[@]} ; i++ )) do
        if [ $i -eq 0 ] 
            then echo "@\"${PROPERTY_NAMES[$i]}\"," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        elif [ $i -eq $(($PROPERTY_NAMES_LENGTH-1)) ]
            then echo "             @\"${PROPERTY_NAMES[$i]}\"];" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        else
            echo "             @\"${PROPERTY_NAMES[$i]}\"," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        fi
    done
    echo "}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "
    " >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"


    echo "- (NSArray *)columnNames {" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo -n "    return @[" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    # add SQLite attributes to the columnNames method within the .m
    # file (these propertyNames in propertyKeysMatchingAttributeColumns)
    COL_NAMES_LENGTH=${#COL_NAMES[@]}
    for (( i = 0 ; i < ${#COL_NAMES[@]} ; i++ )) do
        if [ $i -eq 0 ] 
            then echo "@\"${COL_NAMES[$i]}\"," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        elif [ $i -eq $(($COL_NAMES_LENGTH-1)) ]
            then echo "             @\"${COL_NAMES[$i]}\"];" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        else
            echo "             @\"${COL_NAMES[$i]}\"," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        fi
    done
    echo "}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "
    " >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"


    # add affinities to the .m file
    echo "- (NSArray *)columnTypesForAttributeColumns {" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo -n "    return @[" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    AFFINITIES_FOR_CLASS_LENGTH=${#AFFINITIES_FOR_CLASS[@]}
    for (( i = 0 ; i < ${#AFFINITIES_FOR_CLASS[@]} ; i++ )) do
        if [ $i -eq 0 ] 
            then echo "${AFFINITIES_FOR_CLASS[$i]}," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        elif [ $i -eq $(($AFFINITIES_FOR_CLASS_LENGTH-1)) ]
            then echo "             ${AFFINITIES_FOR_CLASS[$i]}];" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        else
            echo "             ${AFFINITIES_FOR_CLASS[$i]}," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
        fi
    done
    echo "}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "
    " >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"


    # add SQLiteStipulationsForMapping method
    # method within the .m file
    NON_CAMEL_CASE_NAMES_LENGTH=${#NON_CAMEL_CASE_NAMES[@]}
    echo "- (NSArray *)SQLiteStipulationsForMapping {" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo -n "    return @[[LabQLiteStipulation stipulationWithAttribute:"  >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    for (( j = 0 ; j < ${#NON_CAMEL_CASE_NAMES[@]} ; j++ )) do
        if [ $j -eq 0 ]
            then
            echo "@\"${NON_CAMEL_CASE_NAMES[$j]}\"" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                            binaryOperator:SQLite3BinaryOperatorEquals" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                                     value:self.${PROPERTY_NAMES[$j]}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                                  affinity:self.columnTypesForAttributeColumns[${j}]"  >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                  precedingLogicalOperator:nil" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            if [ $NON_CAMEL_CASE_NAMES_LENGTH -eq 1 ]
            then
                echo "                                                      error:nil]" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            else
                echo "                                                      error:nil]," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            fi
        else
            echo "             [LabQLiteStipulation stipulationWithAttribute:@\"${NON_CAMEL_CASE_NAMES[$j]}\"" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                            binaryOperator:SQLite3BinaryOperatorEquals" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                                     value:self.${PROPERTY_NAMES[$j]}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            echo "                                                  affinity:self.columnTypesForAttributeColumns[${j}]"  >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            if [ $j -lt $(($NON_CAMEL_CASE_NAMES_LENGTH - 1)) ]
            then
                echo "                                  precedingLogicalOperator:SQLite3LogicalOperatorAND]," >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            else
                echo "                                  precedingLogicalOperator:SQLite3LogicalOperatorAND]" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
            fi
        fi
    done
    echo "            ];" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "}" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"
    echo "@end" >> "$LABQLITEROW_SUBCLASSES_OUT_PATH/$CAMEL_CASE_CLASS.m"

done



#   get the columns of t
#   For each column c
#       evaluate the type of data of c
#       create the proper property in Objective-C for c in .h
#       

echo "$(tput setaf 4)Model Generator>$(tput sgr0) Model generation complete!"

