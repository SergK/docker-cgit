# store filename and extension in local vars
BASENAME="$1"
EXTENSION="${BASENAME##*.}"

[ "${BASENAME}" = "${EXTENSION}" ] && EXTENSION=txt
[ -z "${EXTENSION}" ] && EXTENSION=txt

# map Makefile and Makefile.* to .mk
[ "${BASENAME%%.*}" = "Makefile" ] && EXTENSION=mk

# This is for version 3
exec highlight --force --inline-css -f -I -O xhtml -S "$EXTENSION" 2>/dev/null
