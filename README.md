# MCScramble

### Introduction
This is a Perl script that scrambles the choices in multiple choice questions in Latex files that use the [ExamDesign](https://ctan.org/tex-archive/macros/latex/contrib/examdesign?lang=en) class as the library does not have that feature. The script in addition will add an additional line in the Latex file that sets a random seed so the exam can be reproduced and also modified. 

You can specify the number of different versions you want of the latex file. The script will make a tex file for each version. To scramble the order of the questions, use the built in scramble option in ExamDesign.

### How To Use
1. Copy MCScramble.pl to the directory of the Latex file you want to scramble
2. type: perl MCScramble.pl <Latex File Name> <Number of Versions>
  * example: perl MCScramble.pl FinalExam.tex 4
    * will produce 4 versions the Final Exam with the choices in the multiple choice questions scrambled
3. scrambled versions will appear as ver_1.tex ver_2.tex ... in the same directory
