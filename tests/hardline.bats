#!/usr/bin/env bats
#
# CLI-contract tests for hardline. These assert behavior that holds on ANY host
# regardless of its actual security posture — argument handling, output shape,
# valid JSON, exit codes. The findings themselves depend on the machine, so we
# don't assert specific grades.

setup() {
	HL="${BATS_TEST_DIRNAME}/../hardline"
}

@test "prints version" {
	run "$HL" --version
	[ "$status" -eq 0 ]
	[[ "$output" == hardline\ * ]]
}

@test "help exits cleanly and mentions usage" {
	run "$HL" --help
	[ "$status" -eq 0 ]
	[[ "$output" == *Usage:* ]]
}

@test "unknown flag exits 2" {
	run "$HL" --definitely-not-a-flag
	[ "$status" -eq 2 ]
	[[ "$output" == *"unknown option"* ]]
}

@test "json output is valid and carries a grade" {
	run "$HL" --json
	# exit is 0 or 1 (1 = some FAIL), never a crash
	[ "$status" -eq 0 ] || [ "$status" -eq 1 ]
	echo "$output" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert "grade" in d and "checks" in d'
}

@test "no-color output contains no ANSI escapes" {
	run "$HL" --no-color --quiet
	[ "$status" -eq 0 ] || [ "$status" -eq 1 ]
	# no ESC (0x1b) bytes in the stream
	! printf '%s' "$output" | grep -q $'\x1b'
}

@test "quiet mode hides PASS lines" {
	run "$HL" --no-color --quiet
	[[ "$output" != *"[PASS]"* ]]
}
