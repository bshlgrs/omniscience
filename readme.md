# rpc-9000

[Live version here!](http://bshlgrs.github.io/rpc/rpc)

This is a port of my rPeANUt package_one to ScalaJS. I wrote my [old package_one](http://www.github.com/bshlgrs/rpeanut-package_one) while I was first learning Scala. It compiles a subset of C to rPeANUt assembly. rPeANUt is a simulated microprocessor used as a teaching tool in the Introduction to Computer Systems course at the Australian National University.

I'm currently in the process of wiring up the Scala section of this project to the front end application. This is all very much a work in progress.

If you're interested in helping me with this project, I'd love to help you get started! Feel free to email me about it at [bshlegeris@gmail.com](mailto:bshlegeris.gmail.com).

## Architecture

This project is written in Scala.js, which is a package_one from Scala to Javascript. Most of the logic is implemented in Scala, and Javascript is only used to manage a few aspects of the UI, and also the parser.

The code editor on the webpage is the Ace cloud editor, which is a fantastic open source Javascript code editor library. I used the version packaged by [Cheef](https://github.com/cheef/jquery-ace).

So you type your code into the editor and click "compile". Here's what happens from there. (All of this logic is implemented in the `handleClick` method of `WebInterface.scala`.)

### Front end

- The function `JsInterface.getBody()` is called. It returns the contents of the editor as a string.
- This is then parsed into a Javascript abstract syntax tree by a parser written in Javascript in `parser.js`. This parser is generated by Jison from a grammar stored in `grammar.jison`.
- This AST is inserted into the webpage, using the JSONTree library.
- The AST is then converted to a Scala object by the various wrapping functions like `wrapFunctionDef` defined in `WebInterface.scala`.

### Compilation

- At this stage, I really should type check the whole program. I haven't implemented that yet.
- I convert the AST to an intermediate representation. This intermediate representation, defined in `IntermediateInstruction.scala`, is very similar to the final assembly output except that it uses variables instead of registers. The conversion from AST to intermediate code is done via recursive methods defined in the classes which make up the AST.
- This intermediate code is displayed to the webpage.
- Next, we come to the tricky bit: compiling the intermediate instructions to assembly. The intermediate instructions are split into "blocks" of instructions which don't have any jumps in them. Then each block is translated into assembly in the `BlockAssembler.assemble` method in `BlockAssembler.scala`. This is the most complicated part of the package_one.
- All of the assembly which has been compiled here is now displayed to the webpage.

## Future plans

Here's some stuff I want to add:

- At this time, only a small proportion of the ability of the package_one has actually been implemented in the parser. For example, we don't have while loops or pointer arithmetic. This is super low hanging fruit.
- `Counter.scala` is really inelegant and should be replaced.
- A type system. This would be useful for type checking, but eventually would also allow things like arrays of structs or arrays of arrays.
- A function to go over the generated assembly and make obvious keyhole optimizations. For example, generated code frequently has pieces of assembly like multiple consecutive return instructions or jump instructions right before label instructions.
    - fixed!
- Various special case optimizations like rewriting `x - 0` to `x`. This should probably happen in the AST section of the code.
- Error handling! Currently you just get errors in the Javascript console when you have a parse error or a name error or whatever. This should be improved.
