#include "util.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifndef _MSC_VER
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#define _getcwd getcwd
#define _chdir chdir
#define _mkdir mkdir
#define _rmdir rmdir
#else
#include <direct.h>
#include "dirent.h"
/*#undef CopyFile*/
/*#undef DeleteFile*/
#endif

void ext_strip(const char* filename, char* out, size_t len)
{
  const char* endp;
  size_t plen, copylen;

  /* get last dot pointer */
  endp = strrchr(filename, '.');

  /* if contains no extension, returns filename */
  if (!endp)
  {
    if (len > 0)
    {
      strncpy(out, filename, len);
      out[len] = 0;
    }
    return;
  }

  /* get extension length */
  plen = endp - filename;
  copylen = len < plen ? len : plen;

  /* copy extension */
  strncpy(out, filename, copylen);
  out[copylen < len ? copylen : len-1] = 0;
}

void ext_extract(const char* filename, char* out, size_t len)
{
  const char* beginp;
  size_t plen, copylen;

  /* get string after the extension */
  beginp = strrchr(filename, '.');
  if (beginp) ++beginp;

  /* if contains no extension, returns empty string */
  if (!beginp)
  {
    if (len > 0) out[0] = 0;
    return;
  }

  /* get filename length */
  plen = strlen(filename);
  if (beginp) plen -= beginp - filename;
  copylen = len < plen ? len : plen;

  /* copy filename */
  strncpy(out, beginp ? beginp : filename, copylen);
  out[copylen < len ? copylen : len-1] = 0;
}

void dir_strip(const char* filename, char* out, size_t len)
{
  const char* fp;
  const char* bp;
  const char* beginp;
  size_t plen, copylen;

  /* get string after the path */
  fp = strrchr(filename, '/');
  bp = strrchr(filename, '\\');
  beginp = (fp > bp) ? fp : bp;
  if (beginp) ++beginp;

  /* get filename length */
  plen = strlen(filename);
  if (beginp) plen -= beginp - filename;
  copylen = len < plen ? len : plen;

  /* copy filename */
  strncpy(out, beginp ? beginp : filename, copylen);
  out[copylen < len ? copylen : len-1] = 0;
}

void dir_extract(const char* filename, char* out, size_t len)
{
  const char* fp;
  const char* bp;
  const char* endp;
  size_t plen, copylen;

  /* get last separator pointer */
  fp = strrchr(filename, '/');
  bp = strrchr(filename, '\\');
  endp = (fp > bp) ? fp : bp;

  /* if contains no path, returns empty string */
  if (!endp)
  {
    if (len > 0) out[0] = 0;
    return;
  }

  /* get path length */
  plen = endp - filename;
  copylen = len < plen ? len : plen;

  /* copy path */
  strncpy(out, filename, copylen);
  out[copylen < len ? copylen : len-1] = 0;
}

bool_t dir_contents(const char* path, char* out, size_t len)
{
  DIR* d;
  struct dirent* entry;

  /* open directory */
  d = (DIR*)opendir(path);
  if (d == NULL) return FALSE;

  /* copy directory contents */
  if (len > 0) out[0] = 0;
  while ((entry = (struct dirent*)readdir(d)))
  {
    snprintf(out, len, strlen(out) > 0 ? "%s\n%s" : "%s%s", out, entry->d_name);
  }

  /* close directory */
  closedir(d);

  return TRUE;
}

void dir_current(char* out, size_t len)
{
  _getcwd(out, len);
}

bool_t dir_change(const char* path)
{
  return _chdir(path) == 0;
}

int str_casecmp(char const *a, char const *b)
{
    for (;; a++, b++)
    {
        int d = tolower((unsigned char)*a) - tolower((unsigned char)*b);
        if (d != 0 || !*a) return d;
    }
}

void str_write(const char* str, const char* filename, bool_t append)
{
  FILE* f;

  /* open file to write or append */
  f = fopen(filename, append ? "ab" : "wb");

  /* if it could not be opened, return */
  if (!f) return;

  /* write string buffer */
  fwrite(str, sizeof(char), strlen(str), f);

  /* close file */
  fclose(f);
}
