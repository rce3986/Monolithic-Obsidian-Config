This page lists out the time worked on a particular program on a daily basis. 
Times should be entered into the daily note by pressing `Ctrl + Shift + ;` and then specifying the program after the `#`.
Enter `none` if not charging any program.

```dataviewjs
const pages = dv.pages('"Daily"');
const timeEntryRegex = /(\d{2}:\d{2}) (.*)/g;

var tableEntries = [];
for (let [_, p] of Object.entries(pages.values)) 
{
	// Skip if older than 2 weeks.
	if (new Date().getTime() - p.file.cday > 1.21e9)
	{
		continue;
	}

	// Collect time entries in the current page.
	var timeEntries = [];
	const content = await dv.io.load(p.file.path);
	for (const match of content.matchAll(timeEntryRegex))
	{
		timeEntries.push([
			match[1],
			match[2].trim(),
		]);
	}

	// Consolidate time entries by program.
	var programToHours = {};
	for (let i = 1; i < timeEntries.length; i++)
	{
		// Only add program hours.
		let program = timeEntries[i-1][1];
		if (program == "#none") {
			continue;
		}

		// Find diff in time from previous entry.
		let startTime = createDate(timeEntries[i-1][0]);
		let endTime = createDate(timeEntries[i][0]);
		let diffMs = endTime.getTime() - startTime.getTime();
		let diffHrs = diffMs / 1000 / 60 / 60;

		// Add to existing hours for that program.
		programToHours[program] = (programToHours[program] || 0) + diffHrs
	}

	// Add to table.
	for (let [program, hours] of Object.entries(programToHours))
	{
		tableEntries.push([
			p.file.link,
			hours,
			program,
			p.file.cday, // for sorting
		]);
	}	
}

// param: string in the format HH:mm
// returns: a Date object of that time
function createDate(time) {
	var hr = time.split(":")[0];
	var min = time.split(":")[1];
	var now = new Date();
	now.setHours(hr, min, 0, 0);
	return now;
}

dv.table(
	["File", "Hours", "Program"],
	tableEntries
		.sort( (v1, v2) => {
			return v2[3] - v1[3] // sort by day
		} )
		.map( v => [
			v[0],
			v[1].toFixed(1), // display hours in decimal form
			v[2],
		] )
);
```