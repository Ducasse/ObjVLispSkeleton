Class {
	#name : #ObjExampleTest,
	#superclass : #TestCase,
	#type : #variable,
	#category : #'ObjV-AdvancedTests'
}

{ #category : #'first user-defined metaclasses' }
ObjExampleTest class >> setMetaclassDefinition [
	"self setMetaclassDefinition"

	| setClass |
	setClass := Obj ObjClass
				send: #new
				withArguments: #(#(#name: #ObjSet #iv: #(#myInstances) #superclass: #ObjClass)).	"initialize on a metaclass"
	setClass 
		addMethod: #initialize
		args: 'initArray'
		withBody: 
			'
			objself binarySuper: #initialize with: initArray from: superclassOfClassDefiningTheMethod.
			objself send: #setIV
				withArguments: (Array with: #myInstances with: OrderedCollection new).
			objself'.

	setClass addUnaryMethod: #instances
		withBody: 'objself binarySend: #getIV with: #myInstances'.

	setClass addMethod: #new
		args: 'initArray'
		withBody: 
			'| newInst others |
			newInst := objself super: #new withArguments: (Array with: initArray) from: superclassOfClassDefiningTheMethod.
			others := objself unarySend: #instances.
			others := others add: newInst;
						yourself.
			objself send: #setIV withArguments: (Array with: #myInstances with: others).
			newInst'
]

{ #category : #'first user-defined metaclasses' }
ObjExampleTest class >> setMetaclassExample [
	"self setMetaclassExample"

	| memoPointClass |
	self setMetaclassDefinition.
	memoPointClass := Obj ObjSet 
						send: #new
						withArguments: #(#(#name: #ObjMemoPoint  #iv: #() #superclass: #ObjPoint)).
	memoPointClass send: #new withArguments: #(#(#x: 24 #y: 6)).
	memoPointClass send: #new withArguments: #(#(#x: 15 #y: 10)).
	^memoPointClass send: #instances withArguments: #().
]

{ #category : #setup }
ObjExampleTest >> abstractMetaclassDefinition [
 
	(Obj giveClassNamed: #ObjClass)
					 		send: #new
							withArguments: #(#(#name: #ObjAbstractClass #iv: #() #superclass: #ObjClass)).
	Obj ObjAbstractClass 
		addMethod: #new
		args: 'initArray'
		withBody: 
			' objself error: '' the class '' , objself objName asString , '' is abstract'''
]

{ #category : #setup }
ObjExampleTest >> defineObjAbstractPoint [

	(Obj ObjAbstractClass)
		send: #new
		withArguments: #(#(#name: #ObjAbstractPoint #iv: #() #superclass: #ObjObject)).
	Obj ObjAbstractPoint
		addUnaryMethod: #givex
		withBody: 'objself valueOfInstanceVariable: #x '.
	Obj ObjAbstractPoint 
		addUnaryMethod: #display
		withBody: 
			'Transcript cr;
				show: ''aPoint with x = ''.
			Transcript show: (objself send: #givex withArguments: #()) printString;
				cr'.
]

{ #category : #setup }
ObjExampleTest >> defineObjPoint [
	Obj ObjClass send: #new
		withArguments: #(#(#name: #ObjPoint #iv: #(#x #y) #superclass: #ObjAbstractPoint)).
]

{ #category : #setup }
ObjExampleTest >> setUp [

	Obj bootstrap.
	self abstractMetaclassDefinition.
	self defineObjAbstractPoint.
	self defineObjPoint
]

{ #category : #'test abstract' }
ObjExampleTest >> testAbstractMetaclassExample [

	self should: [Obj ObjAbstractClass send: #new withArguments: #(#(#x: 24 #y: 6))] raise: Error.
]

{ #category : #'test abstract' }
ObjExampleTest >> testAbstractMetaclassExampleWithConcreteSubclass [

	self shouldnt: [Obj ObjPoint send: #new withArguments: #(#(#x: 24 #y: 6))]
		raise: Error
]

{ #category : #'test abstract' }
ObjExampleTest >> testColoredPoint [

	| coloredPointClass aColoredPoint |
	coloredPointClass := Obj ObjClass
						 	send: #new 
							withArguments: #((#name: #ObjColoredPoint 
							           		   #iv: #(#color) 
							            	  #superclass: #ObjPoint)).

	aColoredPoint := coloredPointClass send: #new withArguments: #((#x: 24 #y: 6 #color: #blue)).	
	"first messages sent"

	self 
		assert: (aColoredPoint send: #getIV withArguments: #(#x)) 
		equals: 24.
	aColoredPoint send: #setIV withArguments: #(#x 25).
	self assert: (aColoredPoint send: #getIV withArguments: #(#x)) 
		equals: 25.

	self 
		assert: (aColoredPoint send: #getIV withArguments: #(#color)) 
		equals: #blue.	

	"adding some methods"

	coloredPointClass 
		addUnaryMethod: #giveColor
		withBody: 'objself send: #getIV withArguments: #(#color)'.

	coloredPointClass 
		addMethod: #setColor
		args: 'col'
		withBody:' objself send: #setIV withArguments: (Array with: #color with: col)'.

	coloredPointClass addUnaryMethod: #display
		withBody:  
			'objself super: #display withArguments: #() from: superclassOfClassDefiningTheMethod.
			Transcript cr;
				show: '' with Color = ''.
			Transcript show: (objself send: #giveColor withArguments: #()) printString;
				cr'.
	self 
		assert: (aColoredPoint send: #giveColor withArguments: #()) 
		equals: #blue.
	
	self 
		assert: (aColoredPoint send: #givex withArguments: #()) 
		equals: 25.
	
	aColoredPoint send: #display withArguments: #().
]
