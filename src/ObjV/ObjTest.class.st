Class {
	#name : #ObjTest,
	#superclass : #TestCase,
	#instVars : [
		'objectClass',
		'aPoint',
		'coloredPointClass',
		'pointClass',
		'classClass',
		'aColoredPoint',
		'aIncrementalColoredPoint',
		'incrementalColoredPointClass'
	],
	#category : #'ObjV-Core'
}

{ #category : #setup }
ObjTest >> assembleClassClass [
	classClass := Obj new: 6.
	classClass at: classClass offsetForName put: #ObjClass.
	classClass at: classClass offsetForClassId put: #ObjClass.
	classClass at: classClass offsetForIVs
		put: #(#class #name #superclass #iv #keywords #methodDict).
	classClass at: classClass offsetForKeywords
		put: #(#name: #superclass: #iv: #keywords: #methodDict:).
	classClass at: classClass offsetForSuperclassId put: #ObjObject.
	classClass at: classClass offsetForMethodDict
		put: (IdentityDictionary new).
	Obj declareClass: classClass
]

{ #category : #setup }
ObjTest >> assembleColoredInstance [
	aColoredPoint := Obj new: 4.
	aColoredPoint at: 1 put: #ObjColoredPoint.
	aColoredPoint at: 2 put: 10.
	aColoredPoint at: 3 put: 15.
	aColoredPoint at: 4 put: #blue
]

{ #category : #setup }
ObjTest >> assembleColoredPointClass [
	coloredPointClass := Obj new: 6.
	coloredPointClass at: pointClass offsetForName put: #ObjColoredPoint.
	coloredPointClass at: pointClass offsetForClassId put: #ObjClass.
	
	"Here the initialize of metaclass is not available so we perform the instance variable lookup by hand."
	coloredPointClass at: pointClass offsetForIVs put: #( #class #x #y #color).
	coloredPointClass at: pointClass offsetForSuperclassId put: #ObjPoint.
	coloredPointClass at: pointClass offsetForMethodDict
		put: (IdentityDictionary new).
	Obj declareClass: coloredPointClass.

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #print
		put: 
			([ :superclassOfClassDefiningTheMethod | 
				[:objself | 
				Transcript show: 'I''am a colored point';
				cr]] value: pointClass).

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #foo
		put: 
			([ :superclassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #foo withArguments: #() from: superclassOfClassDefiningTheMethod) + (objself super: #foo withArguments: #() from: superclassOfClassDefiningTheMethod)
				]] value: pointClass).

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #bar
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #bar withArguments: #() from: superClassOfClassDefiningTheMethod) + (objself super: #bar withArguments:#() from: superClassOfClassDefiningTheMethod)]
			] value: pointClass).
]

{ #category : #setup }
ObjTest >> assembleIncrementalColoredInstance [
	
	aIncrementalColoredPoint := Obj new: 4.
	aIncrementalColoredPoint at: 1 put: #ObjIncrementalColoredPoint.
	aIncrementalColoredPoint at: 2 put: 10.
	aIncrementalColoredPoint at: 3 put: 15.
	aIncrementalColoredPoint at: 4 put: #blue
]

{ #category : #setup }
ObjTest >> assembleIncrementalColoredPointClass [
	incrementalColoredPointClass := Obj new: 6.
	incrementalColoredPointClass at: pointClass offsetForName put: #ObjIncrementalColoredPoint.
	incrementalColoredPointClass at: pointClass offsetForClassId put: #ObjClass.
	
	"Some tests will invoke by hand computeIV... so we do not have to hardcode the sequence."
	incrementalColoredPointClass at: pointClass offsetForIVs put: #( #color).
	incrementalColoredPointClass at: pointClass offsetForSuperclassId put: #ObjPoint.
	incrementalColoredPointClass at: pointClass offsetForMethodDict
		put: (IdentityDictionary new).
	Obj declareClass: incrementalColoredPointClass.

	(incrementalColoredPointClass at: incrementalColoredPointClass offsetForMethodDict) at: #print
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				Transcript show: 'I''am a colored point';
				cr]] value: pointClass).

	(incrementalColoredPointClass at: incrementalColoredPointClass offsetForMethodDict) at: #foo
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #foo withArguments: #() from: superClassOfClassDefiningTheMethod) + (objself super: #foo withArguments: #() from: superClassOfClassDefiningTheMethod)
				]] value: pointClass).

	(incrementalColoredPointClass at: incrementalColoredPointClass offsetForMethodDict) at: #bar
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #bar withArguments: #() from: superClassOfClassDefiningTheMethod) + (objself super: #bar withArguments: #() from: superClassOfClassDefiningTheMethod)]
			] value: pointClass).
]

{ #category : #setup }
ObjTest >> assembleObjectClass [
	objectClass := Obj new: 6.
	objectClass at: objectClass offsetForName put: #ObjObject.
	objectClass at: objectClass offsetForClassId put: #ObjClass.
	objectClass at: objectClass offsetForIVs put: #(#class).
	objectClass at: objectClass offsetForKeywords put: #().
	objectClass at: objectClass offsetForSuperclassId put: nil.
	objectClass at: objectClass offsetForMethodDict put: (IdentityDictionary new).
	Obj declareClass: objectClass.

	"here I simulate by hand the way superclass is captured for super lookup, I value the block with nil for now to represent
	the superclass of ObjObject"

	(objectClass at: objectClass offsetForMethodDict) at: #print
		put: 
			([:superclassOfClassDefiningTheMethod |
				[:objself | 
			Transcript show: 'I''am an Object';
				cr]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #error
		put: 
			([:superclassOfClassDefiningTheMethod |
				[:object :arrayOfArguments | 
			Transcript show: 'Error: selector ' , arrayOfArguments first printString , ' not understood';
				cr.
				Error signal]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #getIV
		put: ([:superclassOfClassDefiningTheMethod | [:object :iv | object valueOfInstanceVariable: iv]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #setIV
		put: 
			([:superclassOfClassDefiningTheMethod | [:object :iv :val | 
			object at: (object ivOffset: iv) put: val]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #bar
		put: 
			([:superclassOfClassDefiningTheMethod | [:objself | 
					5]] value: nil).
]

{ #category : #setup }
ObjTest >> assemblePointClass [
	| cl |
	cl := Obj giveClassNamed: #ObjClass.
	pointClass := Obj new: (cl at: cl offsetForIVs) size.
	pointClass at: pointClass offsetForName put: #ObjPoint.
	pointClass at: pointClass offsetForClassId put: #ObjClass.
	pointClass at: pointClass offsetForIVs put: #(#class #x #y).
	pointClass at: pointClass offsetForKeywords put: #(#x: #y:).
	pointClass at: pointClass offsetForSuperclassId put: #ObjObject.
	pointClass at: pointClass offsetForMethodDict
		put: (IdentityDictionary new).
	Obj declareClass: pointClass.

	(pointClass at: pointClass offsetForMethodDict) at: #x
		put: ([ :superClassOfClassDefiningTheMethod | [:objself | objself valueOfInstanceVariable: #x]] value: objectClass).

	(pointClass at: pointClass offsetForMethodDict) at: #print
		put: 
			([ :superClassOfClassDefiningTheMethod | [:objself | 
			Transcript show: 'I''am a Point';
				cr]] value: objectClass).

	(pointClass at: pointClass offsetForMethodDict) at: #foo
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				Transcript show: 'ObjPoint>>foo';cr.
				5
				]] value: objectClass)
]

{ #category : #setup }
ObjTest >> assemblePointInstance [
	aPoint := Obj new: 3.
	aPoint at: 1 put: #ObjPoint.
	aPoint at: 2 put: 10.
	aPoint at: 3 put: 15
]

{ #category : #setup }
ObjTest >> setUp [
	"self new setUp"

	Obj initialize.
	self assembleClassClass.
	self assemblePointClass.
	self assembleObjectClass.
	self assembleColoredPointClass.
	self assemblePointInstance.
	self assembleColoredInstance.
	self assembleIncrementalColoredInstance.
	self assembleIncrementalColoredPointClass
]

{ #category : #'step05-tests-allocate' }
ObjTest >> testAllocate [
  "(self  selector: #testAllocate) run"
  | newInstance |
  newInstance := pointClass allocateAnInstance.
  self assert: (newInstance at: 1) = #ObjPoint.
  self assert: (newInstance size) = 3.
  self assert: (newInstance at: 2) isNil.
  self assert: (newInstance at: 3) isNil.
  self assert: (newInstance objClass = pointClass)
]

{ #category : #'utilities tests' }
ObjTest >> testBlockArgsFrom [

	self assert: (Obj new blockArgsFrom: ' abc def ghi ')  = ':abc :def :ghi'.
	self assert: (Obj new blockArgsFrom: 'abc def ghi')  = ':abc :def :ghi'.
	self assert: (Obj new blockArgsFrom: '')  = ''.
]

{ #category : #'utilities tests' }
ObjTest >> testBlockBodyFromHeaderAndBody [

	"a method with one argument: val"
	self assert: (Obj new stringOfBlockBodyFromHeader: 'val' andBody: 'objself send: #setIV 
										 withArguments: (Array with: #x with: val).')
										= '[ :superclassOfClassDefiningTheMethod |
		[ :objself :val |
					 objself send: #setIV 
										 withArguments: (Array with: #x with: val).] ]'.

	"a method without arg"
	self assert: (Obj new stringOfBlockBodyFromHeader: '' andBody: 'objself unarySend: #getx.') 
	='[ :superclassOfClassDefiningTheMethod |
		[ :objself  |
					 objself unarySend: #getx.] ]'
	
]

{ #category : #'step03-tests-class access' }
ObjTest >> testClassAccess [
	"(self  selector: #testClassAccess) run"
	
	self assert: aPoint objClass equals: pointClass
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testErrorRaisedSendWhenErrorInLookup [
	"(self  selector: #testErrorRaisedSendWhenErrorInLookup) run"
	
	self should: [  pointClass sendError: #zork withArgs: { aPoint } ] raise: Error.
	"Open a Transcript to see the message trace"
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testErrorRedefinition [
	"(self  run: #testErrorRedefinition)"
	
	self should: [aPoint send: #zork withArguments: #()] raise: Error.

	(pointClass at: pointClass offsetForMethodDict) at: #error
		put: ([ :superclassOfClassDefiningTheMethod | [:objself :selector | 33]] value: objectClass).
	
	self assert: (aPoint send: #zork withArguments: #()) = 33.

	(pointClass at: pointClass offsetForMethodDict) at: #error
		put: ([ :superclassOfClassDefiningTheMethod | [:objself :selector | 33]] value: objectClass).

	self assert: (aPoint send: #zork withArguments: #(44)) = 33.
]

{ #category : #'step04-tests-iv management' }
ObjTest >> testIVOffsetAskingTheClass [
	"(self  selector: #testIVOffsetAskingTheClass) run"

	self assert: ((pointClass ivClassOffset: #x ) = 2).
	self assert: ((pointClass ivClassOffset: #lulu ) = 0)
]

{ #category : #'step04-tests-iv management' }
ObjTest >> testIVOffsetAskingTheInstance [
	"(self  selector: #testIVOffsetAskingTheInstance) run"

	self assert: (pointClass ivClassOffset: #x) equals: 2.
	self assert: (pointClass ivClassOffset: #lulu) equals: 0
]

{ #category : #'step04-tests-iv management' }
ObjTest >> testIVValue [
	"(self  selector: #testIVOffsetAndValue) run"

	self assert: (aPoint valueOfInstanceVariable: #x) equals: 10
]

{ #category : #'step07-tests-initialize' }
ObjTest >> testInitialize [
	"(self  selector: #testInitialize) run"

	| newInstance  |
	newInstance := pointClass allocateAnInstance.
	newInstance initializeUsing: #(#y: 2 #z: 3 #t: 55 #x: 1).
	self assert: (newInstance at: 1) equals: #ObjPoint.
	self assert: (newInstance at: 2) equals: 1.
	self assert: (newInstance at: 3) equals: 2.
]

{ #category : #'step08-tests-instance variable inheritance' }
ObjTest >> testInstanceVariableInheritance [
	"(self  selector: #testInstanceVariableInheritance) run"

	"a better choice would be to throw an exception if there are duplicates"
	self 
		assert: 
			(Obj new computeNewIVFrom: #(#a #b #c #d)
				with: #(#a #z #b #t))
				equals: #(#a #b #c #d #z #t).
	self assert: 
			(Obj new computeNewIVFrom: #()
				with: #(#a #z #b #t))
			equals: #(#a #z #b #t)
]

{ #category : #'step08-tests-instance variable inheritance' }
ObjTest >> testInstanceVariableInheritanceFromAClass [

	"(self  selector: #testInstanceVariableInheritanceFromAClass) run"
	
	aIncrementalColoredPoint objClass 
		objIVs: (aIncrementalColoredPoint 
							computeNewIVFrom: aPoint objClass objIVs  
							with: aIncrementalColoredPoint objClass objIVs).
	
	self assert: (pointClass ivClassOffset: #x) equals: 2.
	self assert: (incrementalColoredPointClass ivClassOffset: #x) equals: 2.
	

]

{ #category : #'step08-tests-instance variable inheritance' }
ObjTest >> testInstanceVariableInheritanceFromAObject [
	
	aIncrementalColoredPoint objClass 
			objIVs: (aIncrementalColoredPoint 
								computeNewIVFrom: aPoint objClass objIVs  
								with: aIncrementalColoredPoint objClass objIVs).
	
	self assert: (aPoint ivOffset: #x) equals: 2.
	self assert: (aIncrementalColoredPoint ivOffset: #x) equals: 2.
	
	
	
]

{ #category : #'step08-tests-instance variable inheritance' }
ObjTest >> testInstanceVariableInheritanceNotFind [

	self should: [aPoint ivOffset: #zork ] raise: Error.
	
	
	
]

{ #category : #'step08-tests-instance variable inheritance' }
ObjTest >> testInstanceVariableInheritanceNumberOfInstanceVar [

	self assert: (pointClass numberOfIVs) equals: 3.
	self assert: (coloredPointClass numberOfIVs) equals: 4.
	

]

{ #category : #'step06-tests-keywords' }
ObjTest >> testKeywords [
	"(self  selector: #testKeywords) run"

	| dummyObject |
	dummyObject := Obj new.
	self assert: 
			((dummyObject generateKeywords: #(#titi #toto #lulu))
				= #(#titi: #toto: #lulu:)).
	self assert: 
			((dummyObject keywordValue: #x
				getFrom: #(#toto 33 #x 23)
				ifAbsent: 2) = 23).
	self assert: 
			((dummyObject keywordValue: #x
				getFrom: #(#toto 23)
				ifAbsent: 2) = 2).
	self assert: 
			((dummyObject returnValuesFrom: #(#x 22 #y 35) followingSchema: #(#y #yy #x #y))
				= #(35 nil 22 35))
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodDefinition [
	"(self  selector: #testMethodManagment) run"

	self assert: (pointClass doesUnderstand: #x).
	self assert: (pointClass doesUnderstand: #xx) not.

	"define a unary method xx returning the receiver."
	pointClass 
		addMethod: #xx
		args: ''
		withBody: 'objself'.

	self assert: (pointClass doesUnderstand: #xx).
	self assert: (((pointClass bodyOfMethod: #xx) value: 22) = 22).

	"define a unary method returning the slot x of the receiver"
	pointClass 
		addMethod: #getgetx
		args: ''
		withBody: 'objself valueOfInstanceVariable: #x'.
	self assert: (pointClass doesUnderstand: #getgetx).
	self assert: (((pointClass bodyOfMethod: #getgetx) value: aPoint) = 10).
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodLookup [
	"(self  selector: #testMethodLookup) run"
	
	self assert: ((pointClass lookup: #x) isKindOf: BlockClosure)
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testMethodLookupFindSimpleMethod [
	"(self  selector: #testMethodLookupFindSimpleMethod) run"

	self assert: ((pointClass lookup: #x)  isKindOf: BlockClosure)
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testMethodLookupFindSuperMethod [
	"(self  selector: #testMethodLookupFindSuperMethod) run"
	
	self assert: ((coloredPointClass lookup: #x) isKindOf: BlockClosure)
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testMethodLookupStop [
	"(self  selector: #testMethodLookupStop) run"
	
	| foundMethod|
	foundMethod := (pointClass lookup: #zork).
	self assert: foundMethod isNil. 
	"The method zork is NOT implement on pointClass, so nil is returned."
	self should: [ pointClass sendError: #error withArgs: {aPoint}] raise: Error.
	
	foundMethod := (pointClass lookup: #error).
	self assert: (foundMethod isKindOf: BlockClosure).
	self assert: ('*Error*' match: foundMethod printString).
	
	"the message error defined on ObjObject requires two arguments: an object and a selector and it raises 
	an error when executed. Open a Transcript to see the message trace"
	self should:  [((pointClass lookup: #zork) value: 'r' value: #e)] raise: Error .
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodManagement [
	"(self  selector: #testMethodManagment) run"

	self assert: (pointClass doesUnderstand: #x).
	self assert: (pointClass doesUnderstand: #xx) not.
	
	pointClass 
		addMethod: #xx
		args: ''
		withBody: 'objself valueOfInstanceVariable: #x '.
	self assert: (((pointClass bodyOfMethod: #xx) value: aPoint) = 10).
	self assert: (pointClass doesUnderstand: #xx).
	pointClass removeMethod: #xx.
	self assert: (pointClass doesUnderstand: #xx) not.
	self assert: (((pointClass bodyOfMethod: #x) value: aPoint) = 10)
]

{ #category : #'step09-tests-methods-management' }
ObjTest >> testMethodManagmentAddRemoveMethods [
	"(self  selector: #testMethodManagmentAddRemoveMethods) run"

	pointClass 
		addUnaryMethod: #xx
		withBody: 'objself valueOfInstanceVariable: #x '.
	self assert: ((pointClass bodyOfMethod: #xx) value: aPoint) equals: 10.
	self assert: (pointClass doesUnderstand: #xx).
	pointClass removeMethod: #xx.
	self assert: (pointClass doesUnderstand: #xx) not.
	self assert: ((pointClass bodyOfMethod: #x) value: aPoint) equals: 10
]

{ #category : #'step09-tests-methods-management' }
ObjTest >> testMethodManagmentBodyOfMethod [
	"(self selector: #testMethodManagmentBodyOfMethod) run"
	
	self assert: ((pointClass bodyOfMethod: #x) value: aPoint) equals: 10

]

{ #category : #'step09-tests-methods-management' }
ObjTest >> testMethodManagmentNotUnderstandBadMethod [
	"(self  selector: #testMethodManagmentNotUnderstandBadMethod) run"

	self deny: (pointClass doesUnderstand: #xx)
	
]

{ #category : #'step09-tests-methods-management' }
ObjTest >> testMethodManagmentUnderstandGoodMethod [
	"(self  selector: #testMethodManagmentUnderstandGoodMethod) run"

	self assert: (pointClass doesUnderstand: #x).

]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodNotFoundRaiseError [
	"(self  run: #testMethodNotFoundRaiseError)"

	self should: [aPoint send: #zork withArguments: #()] raise: Error.
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodSelfSend [
	"(self  selector: #testMethodSelfSend) run"

	"method found in the class PointClass"
	self assert: ((aPoint send: #x withArguments: #()) = 10).

	"method found in ObjClass"
	self assert: ((aPoint send: #getIV withArguments: #(#x)) = 10).

	"method found in ObjClass"
	aPoint send: #setIV withArguments: #(y 22).
	self assert: ((aPoint send: #getIV withArguments: #(#y)) = 22)
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testMethodSelfSendUnarySend [
	"(self  selector: #testMethodSelfSendUnarySend) run"

	"method found in the class PointClass"
	self assert: ((aPoint send: #x withArguments: #()) = 10).
	"method found in the class PointClass"
	self assert: ((aColoredPoint send: #x withArguments:#()) = 10).

]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodSuperCall [
	"(self  selector: #testMethodSuperCall) run"

	"foo in point return 5"
	self assert: ((aPoint send: #foo withArguments: #()) = 5).

	"foo in colored point is doing super foo + super foo"
	self assert: ((aColoredPoint send: #foo withArguments: #()) = 10).
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testMethodSuperCallOverBigHierarchy [
	"(self  selector: #testMethodSuperCallOverBigHierarchy) run"

	"bar is defined in Object and not on Point"
	self assert: (aPoint send: #bar withArguments: #()) = 5.

	"bar on coloredPoint = super bar + super bar"
	self assert: (aColoredPoint send: #bar withArguments: #()) = 10.
]

{ #category : #'utilities tests' }
ObjTest >> testMethodWithHeaderAndBody [

	"a method simply returning objself"
	self assert: ((pointClass
					methodWithHeader: ''
					andBody: 'objself ') value: 2) = 2.
	
	"a method returning its first none implicit arg"
	self assert: ((pointClass 
					methodWithHeader: 'val'
					andBody: 'val ') value: 2 value: 33) = 33.

	"a method returns its superclass of the class defining the method value"
	"this anonymous method is defined in pointClass so its superclass pointer is objectClass"
	self assert: ((pointClass 
					methodWithHeader: ''
					andBody: ' superclassOfClassDefiningTheMethod ') value: aPoint) = objectClass .

	self assert: ((coloredPointClass 
					methodWithHeader: ''
					andBody: ' superclassOfClassDefiningTheMethod ') value: aPoint) = pointClass .
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testNilWhenErrorInLookup [
	"(self  selector: #testNilWhenErrorInLookup) run"
	
	self assert: (pointClass lookup: #zork) isNil.
	"The method zork is NOT implement on pointClass"
	
]

{ #category : #'step11-tests-extra-message-passing' }
ObjTest >> testPrimitiveStructure [
	"(self selector: #testPrimitiveStructure) run"
	
	self assert: (pointClass objClassId = #ObjClass).
	self assert: ((pointClass objName ) = #ObjPoint).
	self assert: ((pointClass objSuperclassId ) = #ObjObject).
	self assert: ((pointClass objIVs) = #(#class #x #y)).
	self assert: ((pointClass objKeywords) = #(#x: #y:)).
	self assert: ((pointClass objMethodDict) = nil) not
]

{ #category : #'step01-tests-structure of objects' }
ObjTest >> testPrimitiveStructureObjClassId [
	"(self selector: #testPrimitiveStructureObjClassId) run"

	self assert: pointClass objClassId equals: #ObjClass

]

{ #category : #'step01-tests-structure of objects' }
ObjTest >> testPrimitiveStructureObjClassIdForSimpleObject [
	"self run: #testPrimitiveStructureObjClassIdForSimpleObject"

	self assert: aPoint objClassId equals: #ObjPoint

]

{ #category : #'step02-tests-structure of classes' }
ObjTest >> testPrimitiveStructureObjIVs [
	"(self selector: #testPrimitiveStructureObjIVs) run"

	self assert: pointClass objIVs equals: #(#class #x #y)

]

{ #category : #'step02-tests-structure of classes' }
ObjTest >> testPrimitiveStructureObjKeywords [
	"(self selector: #testPrimitiveStructureObjKeywords) run"

	self assert: pointClass objKeywords equals: #(#x: #y:)

]

{ #category : #'step02-tests-structure of classes' }
ObjTest >> testPrimitiveStructureObjMethodDict [
	"(self selector: #testPrimitiveStructureObjMethodDict) run"

	self assert: ((pointClass objMethodDict) = nil) not
]

{ #category : #'step02-tests-structure of classes' }
ObjTest >> testPrimitiveStructureObjName [
	"(self selector: #testPrimitiveStructureObjName) run"

	self assert: ((pointClass objName ) = #ObjPoint).
	
]

{ #category : #'step02-tests-structure of classes' }
ObjTest >> testPrimitiveStructureObjSuperclassId [
	"(self selector: #testPrimitiveStructureObjSuperclassId) run"

	self assert: ((pointClass objSuperclassId ) = #ObjObject).

]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testRaisesErrorSendWhenErrorInLookup [
	"(self  selector: #testRaisesErrorSendWhenErrorInLookup) run"

	self should: [ pointClass send: #zork withArguments: { aPoint } ] raise: Error.
	"Open a Transcript to see the message trace"
]

{ #category : #'step10-tests-message-passing' }
ObjTest >> testSendErrorRaisesErrorSendWhenErrorInLookup [
	"(self  selector: #testSendErrorRaisesErrorSendWhenErrorInLookup) run"
	
	self should: [  pointClass sendError: #zork withArgs: { aPoint } ] raise: Error.
	"Open a Transcript to see the message trace"
]
