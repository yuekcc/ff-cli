import std::os::process;
import std::io;
import std::io::path;
import std::os::win32;

const SW_SHOWNORMAL = 1;

extern fn win32::Win32_HINSTANCE shellExecute(
	win32::Win32_HWND hwnd, 
	win32::Win32_LPCWSTR lpOperation, 
	win32::Win32_LPCWSTR lpFile, 
	win32::Win32_LPCWSTR lpParameters, 
	win32::Win32_LPCWSTR lpDirectory, 
	win32::Win32_INT32 nShowCmd,
) @extern("ShellExecuteW");

fn bool openFile(String target) {
	$if env::WIN32:
		String operation = "open";
		win32::Win32_HINSTANCE res = shellExecute(null, operation.to_temp_utf16()!!, target.to_temp_utf16()!!, null, null, SW_SHOWNORMAL);
		if (res > (win32::Win32_HINSTANCE)32) {
			return true;
		}

		io::eprintfn("Failed to open file (%d)", (int)(iptr)res);
		return false;
	$else
		io::eprintfn("Only work in Windows");
		return false;
	$endif
}

fn int main(int argc, char** argv) {
	if (argc != 2) {
		Path exe_name = path::new(ZString.str_view((ZString)argv[0]))!!;
		io::eprintfn("Usage: %s <FILE_PATH>", exe_name.basename());
		return 1;
	}

	String target_name = ZString.str_view((ZString)argv[1]);
	target_name = path::normalize(target_name)!!;
	return openFile(target_name) ? 0 : 1;
}

