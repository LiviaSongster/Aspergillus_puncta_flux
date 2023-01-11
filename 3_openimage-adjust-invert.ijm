title=getTitle();
run("Split Channels");
//close("C2-"+title);
//selectWindow("C2-"+title);
//run("Enhance Contrast", "saturated=0.35");
//resetMinAndMax();
//run("Grays");
//run("Median...", "radius=1 stack");
//run("Subtract Background...", "rolling=50 stack");
//run("Invert LUT");
selectWindow("C1-"+title);
run("In [+]");

selectWindow("C2-"+title);
run("In [+]");

//run("Enhance Contrast", "saturated=0.35");
run("Grays");
run("Median...", "radius=1 stack");
resetMinAndMax();
run("Subtract Background...", "rolling=50 stack");
run("Invert LUT");
resetMinAndMax();
setMinAndMax(0, 100);
print(getTitle());