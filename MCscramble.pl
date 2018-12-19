#/usr/bin/perl -w

# MIT LICENSE
# Copyright (c) 2016 Jeffrey Wong (contact@jeffreywong.ca)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use strict;

# quit unless we have the correct number of command-line args
my $num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: name.pl filename number-of-versions\n\n";
    exit;
}

print "\n";

#open the file
print "Reading file...\n";
my $file = $ARGV[0];
open(my $read , '<', $file)
	or die "Could not open file: $file \n\n";

#read the file and save it into an array
my @fileStuff;
while(my $line = <$read>){
	push(@fileStuff, $line);
}
close $read;

#create the different versions of the test
my $currentVersion = 1;

while($currentVersion <= $ARGV[1])
{
	# create a new file
	print "Creating Version $currentVersion\n";
	open (my $write, '>', "ver_$currentVersion.tex")
		or die "Could not write file for version $currentVersion\n\n";
	
	# scan the file looking for multiple choice	
	my $fileSize = scalar @fileStuff; # the number of lines in the file
	
	my $currentLine = 0; #current line we are in the file
	my $MCsection = 0; # 1 if in the MC section
	my $inQuestion = 0; #1 if in a question
	my @choices = (); # the array to hold the choices
	while($currentLine < $fileSize)
	{
		# check to see if we are in the MC section
		if(index($fileStuff[$currentLine], "\\begin{multiplechoice}")!= -1)
		{
			$MCsection = 1; #we are in MC section
			print $write $fileStuff[$currentLine]; #print the current line
		}
		#check to see if we are already in MC section
		elsif($MCsection)
		{
			#check if we are already in a question
			if($inQuestion)
			{
				#check to see if we are at the end fo a question
				if(index($fileStuff[$currentLine],"\\end{question}")!= -1)
				{
					#scramble choices
					for(my $i = 0; $i < 100; $i++)
					{
						# select a random choice
						my $randomIndex = int(rand(scalar @choices));
						
						# swap with first choice
						my $temp = $choices[0];
						$choices[0] = $choices[$randomIndex];
						$choices[$randomIndex] = $temp;
						
					}

					#write choices to file
					foreach(@choices)
					{
						print $write $_;
					}

					#write the current line
					print $write $fileStuff[$currentLine];

					#exiting the qustion
					$inQuestion = 0;
				}
				#check if we have a choice
				elsif(index($fileStuff[$currentLine], "\\choice")!= -1)
				{
					# add the choice to our choice array
					push(@choices, $fileStuff[$currentLine]);
				}
				#nothing special, just write the line
				else
				{
					print $write $fileStuff[$currentLine];
				}
			}
			#check if we have a question
			elsif(index($fileStuff[$currentLine], "\\begin{question}")!= -1)
			{
				#set to in question mode
				$inQuestion=1;
				
				#reset choices array
				undef(@choices);
				
				#print the current line to the file
				print $write $fileStuff[$currentLine];
			}
			#check if we are exiting the MC Section
			elsif(index($fileStuff[$currentLine], "\\end{multiplechoice}")!= -1)
			{
				$MCsection = 0; #we are exiting MC section

				#print the current line to the file
				print $write $fileStuff[$currentLine];
			
			}
			#nothing special, just write the line
			else
			{
				print $write $fileStuff[$currentLine];
			}
			
		}
		
		# we need to set a random seed macro so the questions will scramble
		# add the line before we begin the document
		elsif(index($fileStuff[$currentLine], "\\begin{document}")!= -1)
		{
			# generate random seed
			my $randomSeed = int(rand(1000)) + 1;
			
			# add to the document
			print $write "\\setrandomseed{$randomSeed}\n\n";
			
			# print the current line
			print $write $fileStuff[$currentLine];
		}
		#nothing special, just write the line
		else
		{
			print $write $fileStuff[$currentLine];
		}
		
		# go to next line
		$currentLine++;
	}
	close $write;	
	$currentVersion++;
}
print "Scrambling Completed!\n\n";
