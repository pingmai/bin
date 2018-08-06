#include <netdb.h>
#include <stdlib.h>

extern void herror(const char *string);

int
main(int argc, char **argv)
{

  struct hostent *host;

  host = gethostbyname(argv[1]);
    if ( host == NULL ) {
      herror("failed");
      exit(-1);
    }
  exit(0);
}

