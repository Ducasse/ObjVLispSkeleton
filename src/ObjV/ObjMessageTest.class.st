Class {
	#name : #ObjMessageTest,
	#superclass : #TestCase,
	#category : #'ObjV-Experimental'
}

{ #category : #setup }
ObjMessageTest >> setUp [

	Obj bootstrap.
	Obj objClassStructureMessage.
]

{ #category : #tests }
ObjMessageTest >> testMessageClassMethods [
	"self debug: #testMessageClassMethods"
	
	| msg |
	Obj addMessagesForErrorHandling.
	msg := Obj ObjMessage 
				send: #new 
				withArguments: #(#(#receiver: 24 #selector: #factorial)).
	
	self assert: (msg send: #receiver2 withArguments: #()) equals: 24.
	self assert: (msg send: #receiver withArguments: #()) equals: 24.
	self assert: (msg send: #selector withArguments: #()) equals: #factorial.
	
	msg := Obj ObjMessage 
		send: #new 
		withArguments: #(#(#receiver: 24 #selector: #+ arguments: #(25))).
	self assert: (msg send: #arguments withArguments: #())  equals: #(25).


]

{ #category : #tests }
ObjMessageTest >> testMessageClassMethodsDefined [
	"self debug: #testMessageClassMethodsDefined"
	
	| msg |
	Obj addMessagesForErrorHandling.
	self deny: Obj ObjMessage objMethodDict size isZero

]

{ #category : #tests }
ObjMessageTest >> testMessageClassStructureDeclared [

	Obj objClassStructureMessage.
	self assert: Obj ObjMessage objName = #ObjMessage.
	self assert: Obj ObjMessage objClass objName= #ObjClass.
	self assert: Obj ObjMessage objIVs asArray = #(#class #receiver #selector #arguments).
	self assert: Obj ObjMessage objSuperclass = Obj ObjObject
	
]

{ #category : #tests }
ObjMessageTest >> testUsingPrimitivesMessageClassMethods [

	| msg |
	msg := Obj ObjMessage 
		send: #new 
		withArguments: #(#(#receiver: 24 #selector: #factorial)).
	
	self assert: (msg at: 1) equals: #ObjMessage.
	self assert: (msg at: 2) equals: 24.
	self assert: (msg at: 3) equals: #factorial.
	
	msg := Obj ObjMessage 
		send: #new 
		withArguments: #(#(#receiver: 24 #selector: #+ arguments: #(25))).
	self assert: (msg at: 4)  equals: #(25).
]
