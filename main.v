module main

import term
import rand
import time
import fgsoftware1.vloggy.vcolors
import os

struct Tool {
	idx 	int
	name	string
	section	string
}

fn main() {
	banner()
	asky()
}

fn banner() {
	rand.seed([u32(time.now().unix_nano()), u32(time.now().unix())])

	ascii_art := "
	 █████╗ ██████╗  ██████╗ ██╗   ██╗███████╗
	██╔══██╗██╔══██╗██╔════╝ ██║   ██║██╔════╝
	███████║██████╔╝██║  ███╗██║   ██║███████╗
	██╔══██║██╔══██╗██║   ██║██║   ██║╚════██║
	██║  ██║██║  ██║╚██████╔╝╚██████╔╝███████║
	╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝
	"

	lines := ascii_art.str().split("\n")
	width, _ := term.get_terminal_size()

	for line in lines{
		color := vcolors.random_color(line)
		centered_line := center_string(color, width)
		println("${centered_line}")
		time.sleep(50 * time.millisecond)
	}
}

fn setup() []Tool{
	mut tools := []Tool{}

	tools << Tool{
		idx: 0
		name: 'API Keys'
		section: 'utils'
	}

	tools << Tool{
		idx: 1
		name: 'MyIP'
		section: 'utils'
	}

	tools << Tool{
		idx: 10
		name: 'http headers'
		section: 'recon'
	}

	return tools
}

fn asky(){
	tools := setup()

	// Group tools by section
	mut sections := map[string][]Tool{}
	for tool in tools {
		if tool.section !in sections {
			sections[tool.section] = []Tool{}
		}
		sections[tool.section] << tool
	}

	// Get sections in order
	section_order := ['utils', 'recon']
	mut section_lists := [][]string{}

	// Build each section as a list of strings
	for section in section_order {
		if section in sections {
			mut section_lines := []string{}
			section_lines << section.to_upper()
			section_lines << ""
			for tool in sections[section] {
				section_lines << "${tool.idx}) ${tool.name}"
			}
			section_lists << section_lines
		}
	}

	// Find max height
	mut max_height := 0
	for section_lines in section_lists {
		if section_lines.len > max_height {
			max_height = section_lines.len
		}
	}

	// Print sections side by side
	for i in 0 .. max_height {
		mut line := ""
		for j, section_lines in section_lists {
			if i < section_lines.len {
				line += pad_right(section_lines[i], 20)
			} else {
				line += pad_right("", 20)
			}
			if j < section_lists.len - 1 {
				line += "    " // spacing between columns
			}
		}
		println(line)
	}

	println("\nSelect a tool (enter number): ")
	selection := os.input('')
	match selection {
		"0" {
			apikeys()
		}
		else{
			eprintln("Unknown tool!")
		}
	}
}

fn apikeys(){
	println("0) Back")

	println("\nSelect a tool (enter number): ")
	selection := os.input('')
	match selection {
		"0" {
			asky()
		}
		else{
			eprintln("Unknown tool!")
		}
	}
}

fn myip(){

}

fn center_string(s string, width int) string {
	lines := s.split("\n")
	mut centered_lines := []string{}

	for line in lines {
		line_len := line.len
		mut padding := (width - line_len) / 2

		if padding < 0 {
			padding = 0
		}

		centered_lines << " ".repeat(padding) + line
	}

	return centered_lines.join("\n")
}

fn pad_right(s string, width int) string {
	if s.len >= width {
		return s
	}
	return s + ' '.repeat(width - s.len)
}