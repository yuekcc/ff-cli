import std::os::process;
import std::io;

fn int main(int argc, char** argv) {
	String exe_name = ZString.str_view((ZString)argv[0]);

	if (argc != 2) {
		io::eprintfn("Usage: %s <FILE_PATH>", exe_name);
		return 1;
	}

	String target_name = ZString.str_view((ZString)argv[1]);

	String[] cmd = {
		"powershell.exe",
		"-c",
		string::tformat("Invoke-Item \"%s\"", target_name),
	};
	SubProcess child = process::create(cmd, {.inherit_environment = true})!!;
	return 0;
}

