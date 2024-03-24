"
These tests are based on a setup that does not rely on structure for the accessors.
"
Class {
	#name : #RawObjTest,
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
RawObjTest >> assembleClassClass [
	classClass := Obj new: 6.
	classClass at: 2 put: #ObjClass.
	classClass at: 1 put: #ObjClass.
	classClass at: 4 put: #(#class #name #superclass #iv #keywords #methodDict).
	classClass at: 5 put: #(#name: #superclass: #iv: #keywords: #methodDict:).
	classClass at: 3 put: #ObjObject.
	classClass at: 6 put: (IdentityDictionary new).
	Obj declareClass: classClass
]

{ #category : #setup }
RawObjTest >> assembleColoredInstance [
	aColoredPoint := Obj new: 4.
	aColoredPoint at: 1 put: #ObjColoredPoint.
	aColoredPoint at: 2 put: 10.
	aColoredPoint at: 3 put: 15.
	aColoredPoint at: 4 put: #blue
]

{ #category : #setup }
RawObjTest >> assembleColoredPointClass [
	coloredPointClass := Obj new: 6.
	coloredPointClass at: 2 put: #ObjColoredPoint.
	coloredPointClass at: 1 put: #ObjClass.
	"Here the initialize of metaclass is not available so we perform the instance variable lookup by hand."
	coloredPointClass at: 4 put: #( #class #x #y #color).
	coloredPointClass at: 3 put: #ObjPoint.
	coloredPointClass at: 6 put: (IdentityDictionary new).
	Obj declareClass: coloredPointClass.

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #print
		put: 
			([ :superClassOfClassDefiningTheMethod | 
				[:objself | 
				Transcript show: 'I''am a colored point';
				cr]] value: pointClass).

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #foo
		put: 
			([ :superclassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #foo withArguments:#() from: superclassOfClassDefiningTheMethod) + (objself super: #foo withArguments:#() from: superclassOfClassDefiningTheMethod)
				]] value: pointClass).

	(coloredPointClass at: coloredPointClass offsetForMethodDict) at: #bar
		put: 
			([ :superclassOfClassDefiningTheMethod | 
				[:objself | 
				(objself super: #bar withArguments:#() from: superclassOfClassDefiningTheMethod) + (objself super: #bar withArguments:#() from: superclassOfClassDefiningTheMethod)]
			] value: pointClass).
]

{ #category : #setup }
RawObjTest >> assembleIncrementalColoredInstance [
	
	aIncrementalColoredPoint := Obj new: 4.
	aIncrementalColoredPoint at: 1 put: #ObjIncrementalColoredPoint.
	aIncrementalColoredPoint at: 2 put: 10.
	aIncrementalColoredPoint at: 3 put: 15.
	aIncrementalColoredPoint at: 4 put: #blue
]

{ #category : #setup }
RawObjTest >> assembleIncrementalColoredPointClass [
	incrementalColoredPointClass := Obj new: 6.
	incrementalColoredPointClass at: 2 put: #ObjIncrementalColoredPoint.
	incrementalColoredPointClass at: 1 put: #ObjClass.
	"Some tests will invoke by hand computeIV... so we do not have to hardcode the sequence."
	incrementalColoredPointClass at: 4 put: #( #color).
	incrementalColoredPointClass at: 3 put: #ObjPoint.
	incrementalColoredPointClass at: 6 put: (IdentityDictionary new).
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
				(objself super: #bar withArguments: #()  from: superClassOfClassDefiningTheMethod) + (objself super: #bar withArguments: #()  from: superClassOfClassDefiningTheMethod)]
			] value: pointClass).
]

{ #category : #setup }
RawObjTest >> assembleObjectClass [
	objectClass := Obj new: 6.
	objectClass at: 2 put: #ObjObject.
	objectClass at: 1 put: #ObjClass.
	objectClass at: objectClass offsetForIVs put: #(#class).
	objectClass at: objectClass offsetForKeywords put: #().
	objectClass at: objectClass offsetForSuperclassId put: nil.
	objectClass at: objectClass offsetForMethodDict put: (IdentityDictionary new).
	Obj declareClass: objectClass.

	"here I simulate by hand the way superclass is captured for super lookup, I value the block with nil for now to represent
	the superclass of ObjObject"

	(objectClass at: objectClass offsetForMethodDict) at: #print
		put: 
			([:superClassOfClassDefiningTheMethod |
				[:objself | 
			Transcript show: 'I''am an Object';
				cr]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #error
		put: 
			([:superClassOfClassDefiningTheMethod |
				[:object :selector | 
			Transcript show: 'Error: selector ' , selector printString , ' not understood';
				cr.
				Error signal]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #getIV
		put: ([:superClassOfClassDefiningTheMethod | [:object :iv | object valueOfInstanceVariable: iv]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #setIV
		put: 
			([:superClassOfClassDefiningTheMethod | [:object :iv :val | 
			object at: (object ivOffset: iv) put: val]] value: nil).

	(objectClass at: objectClass offsetForMethodDict) at: #bar
		put: 
			([:superClassOfClassDefiningTheMethod | [:objself | 
					5]] value: nil).
]

{ #category : #setup }
RawObjTest >> assemblePointClass [
	| cl |
	cl := Obj giveClassNamed: #ObjClass.
	pointClass := Obj new: (cl at: cl offsetForIVs) size.
	pointClass at: 2 put: #ObjPoint.
	pointClass at: 1 put: #ObjClass.
	pointClass at: 4 put: #(#class #x #y).
	pointClass at: 5 put: #(#x: #y:).
	pointClass at: 3 put: #ObjObject.
	pointClass at: 6 put: (IdentityDictionary new).
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
RawObjTest >> assemblePointInstance [
	aPoint := Obj new: 3.
	aPoint at: 1 put: #ObjPoint.
	aPoint at: 2 put: 10.
	aPoint at: 3 put: 15
]

{ #category : #setup }
RawObjTest >> setUp [
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

{ #category : #'step3-tests-class access' }
RawObjTest >> testClassAccess [
	"(self  selector: #testClassAccess) run"
	
	self assert: aPoint objClass equals: pointClass
]

{ #category : #'step1-tests-structure of objects' }
RawObjTest >> testPrimitiveStructureObjClassId [
	"(self selector: #testPrimitiveStructureObjClassId) run"

	self assert: pointClass objClassId equals: #ObjClass

]

{ #category : #'step1-tests-structure of objects' }
RawObjTest >> testPrimitiveStructureObjClassIdForSimpleObject [
	"self run: #testPrimitiveStructureObjClassIdForSimpleObject"

	self assert: aPoint objClassId equals: #ObjPoint

]

{ #category : #'step2-tests-structure of classes' }
RawObjTest >> testPrimitiveStructureObjIVs [
	"(self selector: #testPrimitiveStructureObjIVs) run"

	self assert: pointClass objIVs equals: #(#class #x #y)

]

{ #category : #'step2-tests-structure of classes' }
RawObjTest >> testPrimitiveStructureObjKeywords [
	"(self selector: #testPrimitiveStructureObjKeywords) run"

	self assert: pointClass objKeywords equals: #(#x: #y:)

]

{ #category : #'step2-tests-structure of classes' }
RawObjTest >> testPrimitiveStructureObjMethodDict [
	"(self selector: #testPrimitiveStructureObjMethodDict) run"

	self assert: ((pointClass objMethodDict) = nil) not
]

{ #category : #'step2-tests-structure of classes' }
RawObjTest >> testPrimitiveStructureObjName [
	"(self selector: #testPrimitiveStructureObjName) run"

	self assert: pointClass objName equals: #ObjPoint
	
]

{ #category : #'step2-tests-structure of classes' }
RawObjTest >> testPrimitiveStructureObjSuperclassId [
	"(self selector: #testPrimitiveStructureObjSuperclassId) run"

	self assert: pointClass objSuperclassId equals: #ObjObject

]
