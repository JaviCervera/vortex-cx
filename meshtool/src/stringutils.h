#ifndef UGINE_STRINGUTILS_H
#define UGINE_STRINGUTILS_H

#include <fstream>
#include <sstream>
#include <vector>

template <typename T>
std::string StringFromNumber(T val) {
	std::ostringstream stream;
	stream << std::fixed << val;
	return stream.str();
}

template <typename T>
T NumberFromString(const std::string str) {
	T number;
	std::istringstream stream(str);
	stream >> number;
	return number;
}

inline std::string ReplaceString(const std::string& str, const std::string& find, const std::string& rep) {
	std::string strcopy = str;
	while ( strcopy.find(find) != std::string::npos ) {
		strcopy.replace(strcopy.find(find), find.length(), rep);
	}
	return strcopy;
}

inline std::string ReadString(const std::string& filename) {
	std::ifstream istream(filename.c_str(), std::ios_base::in | std::ios_base::binary);
	std::stringstream sstream;
	sstream << istream.rdbuf();
	istream.close();
	return sstream.str();
}

inline void WriteString(const std::string& str, const std::string& filename, bool append = true) {
	std::ofstream ostream(filename.c_str(), std::ios_base::out | std::ios_base::binary | (append ? std::ios_base::app : std::ios_base::trunc));
	ostream << str;
	ostream.close();
}

inline std::string StripExt(const std::string& filename) {
	return filename.substr(0, filename.find('.'));
}

inline std::string StripPath(const std::string& filename) {
	std::string filenameCopy = ReplaceString(filename, "\\", "/");
	return filenameCopy.substr(filenameCopy.rfind('/')+1, filenameCopy.length() - filenameCopy.rfind('/')-1);
}

inline std::string ExtractExt(const std::string& filename) {
	return filename.substr(filename.rfind('.')+1, filename.length() - filename.rfind('.')-1);
}

inline std::string ExtractPath(const std::string& filename) {
	std::string filenameCopy = ReplaceString(filename, "\\", "/");
	return filenameCopy.substr(0, filenameCopy.rfind('/'));
}

inline std::vector<std::string> SplitString(const std::string& str, char delim) {
	std::vector<std::string> elems;
	std::stringstream sstream(str);
	std::string item;
	while (std::getline(sstream, item, delim)) {
		elems.push_back(item);
	}
	return elems;
}

#endif // UGINE_STRINGUTILS_H
