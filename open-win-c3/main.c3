import std::os::process;
import std::io;
import std::io::path;

fn int main(int argc, char** argv) {
	Path exe_name = path::new(ZString.str_view((ZString)argv[0]))!!;

	if (argc != 2) {
		io::eprintfn("Usage: %s <FILE_PATH>", exe_name.basename());
		return 1;
	}

	String target_name = ZString.str_view((ZString)argv[1]);
	String script = string::tformat("Invoke-Item \"%s\"", target_name);
	String[] cmd = {
		"powershell.exe",
		"-c",
		script,
	};
	process::create(cmd, {.inherit_environment = true})!!;
	return 0;
}

