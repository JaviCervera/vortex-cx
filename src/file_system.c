#include "../lib/stb/stretchy_buffer.h"
#include "vortex_config.h"
#include "file_system.h"
#include <stdio.h>
#include <string.h>

#define PAK_NAME_SIZE 56
#define PAK_ENTRY_SIZE 64

typedef struct {
    char filename[PAK_NAME_SIZE];
    int offset;
    int size;
} PakEntry;

typedef struct {
    char filename[STRING_SIZE];
    PakEntry* entries;
} PakFile;

static PakFile* _pak_files = NULL;

bool_t _InitPak(PakFile* pak, const char* pakname);
const PakFile* _GetPakForFile(const char* filename);
const PakEntry* _GetPakEntry(const PakFile* pak, const char* entryname);
size_t _GetPakEntrySize(const PakFile* pak, const char* entryname);
bool_t _GetPakEntryContents(const PakFile* pak, const char* entryname, void* buffer);

bool_t AddPak(const char* pakname) {
#ifdef USE_PAK
    PakFile pak;
    int i;

    /* Search for pak in list */
    for (i = 0; i < sb_count(_pak_files); ++i) {
        if (strcmp(_pak_files[i].filename, pakname) == 0) {
            return TRUE;
        }
    }

    /* Try to initialize new Pak */
    if (_InitPak(&pak, pakname)) {
        sb_push(_pak_files, pak);
        return TRUE;
    } else {
        return FALSE;
    }
#else
    return FALSE;
#endif
}

bool_t IsFileInPak(const char* filename) {
#ifdef USE_PAK
    return _GetPakForFile(filename) != NULL;
#else
    return FALSE;
#endif
}

size_t GetFileSize(const char* filename) {
    const PakFile* pak;
    pak = _GetPakForFile(filename);
    if (pak) {
        return _GetPakEntrySize(pak, filename);
    } else {
        FILE* fhandle;
        fhandle = fopen(filename, "rb");
        if (fhandle) {
            size_t size;
            fseek(fhandle, 0, SEEK_END);
            size = ftell(fhandle);
            fclose(fhandle);
            return size;
        } else {
            return 0;
        }
    }
}

bool_t GetFileContents(const char* filename, void* buffer) {
    const PakFile* pak;
    pak = _GetPakForFile(filename);
    if (pak) {
        return _GetPakEntryContents(pak, filename, buffer);
    } else {
        FILE* fhandle;
        fhandle = fopen(filename, "rb");
        if (fhandle) {
            size_t size;
            fseek(fhandle, 0, SEEK_END);
            size = ftell(fhandle);
            fseek(fhandle, 0, SEEK_SET);
            fread(buffer, size, 1, fhandle);
            fclose(fhandle);
            return size;
        } else {
            return 0;
        }
    }
}


/****************************
   Pak files
 ****************************/


#ifdef USE_PAK

typedef struct {
    char id[4];
    int offset;
    int size;
} PakHeader;

bool_t _InitPak(PakFile* pak, const char* pakname) {
    FILE* fhandle;
    fhandle = fopen(pakname, "rb");
    if (fhandle) {
        PakHeader header;
        size_t num_entries;
        size_t i;

        /* Read header */
        fread(&header, sizeof(PakHeader), 1, fhandle);
        if (strncmp(header.id, "PACK", 4) != 0) {
            fclose(fhandle);
            return FALSE;
        }

        /* Set filename */
        strncpy(pak->filename, pakname, STRING_SIZE);
        pak->filename[STRING_SIZE-1] = 0;

        /* Get number of entries */
        num_entries = header.size / PAK_ENTRY_SIZE;

        /* Read all entries */
        pak->entries = NULL;
        for (i = 0; i < num_entries; ++i) {
            PakEntry entry;
            fread(&entry, sizeof(PakEntry), 1, fhandle);
            sb_push(pak->entries, entry);
        }

        fclose(fhandle);
        return TRUE;
    } else {
        return FALSE;
    }
}

const PakFile* _GetPakForFile(const char* filename) {
    int i;

    for (i = sb_count(_pak_files) - 1; i >= 0; --i) {
        if (_GetPakEntry(&_pak_files[i], filename) != NULL) {
            return &_pak_files[i];
        }
    }

    return NULL;
}

const PakEntry* _GetPakEntry(const PakFile* pak, const char* entryname) {
    int i;

    for (i = 0; i < sb_count(pak->entries); ++i) {
        if (strcmp(pak->entries[i].filename, entryname) == 0) {
            return &(pak->entries[i]);
        }
    }
    return NULL;
}

size_t _GetPakEntrySize(const PakFile* pak, const char* entryname) {
    const PakEntry* entry;
    entry = _GetPakEntry(pak, entryname);
    if (entry) {
        return (size_t)entry->size;
    } else {
        return 0;
    }
}

bool_t _GetPakEntryContents(const PakFile* pak, const char* entryname, void* buffer) {
    const PakEntry* entry;
    entry = _GetPakEntry(pak, entryname);
    if (entry) {
        FILE* fhandle;
        fhandle = fopen(pak->filename, "rb");
        if (fhandle) {
            fseek(fhandle, entry->offset, SEEK_SET);
            fread(buffer, entry->size, 1, fhandle);
            fclose(fhandle);
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return FALSE;
    }
}

#endif /* USE_PAK */
