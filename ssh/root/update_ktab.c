#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void main()
{
  setreuid(geteuid(), geteuid());
  system("mv /home/kdc/krb5.keytab /etc/krb5.keytab");
  return;
}
