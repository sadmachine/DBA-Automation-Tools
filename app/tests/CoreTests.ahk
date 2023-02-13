#Include <@>

class CoreTests
{
    class TypeOf
    {

        EmptyExplicitArrayIsEmpty()
        {
            typeOf := @.typeOf(Array())
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyExplicitObjectIsEmpty()
        {
            typeOf := @.typeOf(Object())
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyImplicitArrayIsEmpty()
        {
            typeOf := @.typeOf([])
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyImplicitObjectIsEmpty()
        {
            typeOf := @.typeOf({})
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        ImplicitArrayIsArray()
        {
            typeOf := @.typeOf(["A", "B", "C"])
            YUnit.assert(typeOf == "Array", "Found: " typeOf)

        }

        ObjectWithNumericKeysIsArray()
        {
            typeOf := @.typeOf({1: "A", 2: "B", 3: "C"})
            YUnit.assert(typeOf == "Array", "Found: " typeOf)
        }

        ObjectWithStringNumericKeysIsArray()
        {
            typeOf := @.typeOf({"1": "A", "2": "B", "3": "C"})
            YUnit.assert(typeOf == "Array", "Found: " typeOf)
        }

        ObjectWithStringKeysIsObject()
        {
            typeOf := @.typeOf({"a": "A", "b": "B", "c": "C"})
            YUnit.assert(typeOf == "Object", "Found: " typeOf)
        }

        ObjectWithMixedTypeKeysIsObject()
        {
            typeOf := @.typeOf({"a": "A", "1": "B", 3: "C"})
            YUnit.assert(typeOf == "Object", "Found: " typeOf)
        }

        ObjectWith__ClassKeyIsClassName()
        {
            typeOf := @.typeOf({"__Class": "ClassName", "a": "A", "1": "B", 3: "C"})
            YUnit.assert(typeOf == "ClassName", "Found: " typeOf)
        }

        ClassIsFullyQualifiedClassName()
        {
            typeOf := @.typeOf(new @.RequiredFieldException())
            YUnit.assert(typeOf == "@.RequiredFieldException", "Found: " typeOf)
        }

        SingleDigitIsDigit()
        {
            typeOf := @.typeOf(1)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)

            typeOf := @.typeOf(0)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)
        }

        MultipleDigitIsDigit()
        {
            typeOf := @.typeOf(123)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)
        }

        FloatIsFloat()
        {
            typeOf := @.typeOf(1.23)
            YUnit.assert(typeOf == "Float", "Found: " typeOf)
        }

        NegativeFloatIsFloat()
        {
            typeOf := @.typeOf(-1.23)
            YUnit.assert(typeOf == "Float", "Found: " typeOf)
        }

        HexadecimalIsHexadecimal()
        {
            typeOf := @.typeOf(0x0AEF)
            YUnit.assert(typeOf == "Hexadecimal", "Found: " typeOf)
        }

        NegativeSingleDigitIsInteger()
        {
            typeOf := @.typeOf(-1)
            YUnit.assert(typeOf == "Integer", "Found: " typeOf)
        }

        NegativeMultiDigitIsInteger()
        {
            typeOf := @.typeOf(-1234)
            YUnit.assert(typeOf == "Integer", "Found: " typeOf)
        }

        StringWithSpaceCharactersIsEmpty()
        {
            typeOf := @.typeOf(" `n`t")
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyStringIsEmpty()
        {
            typeOf := @.typeOf(" `n`t")
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        StringIsString()
        {
            typeOf := @.typeOf("String 123 yup 1.234")
            YUnit.assert(typeOf == "String", "Found: " typeOf)
        }
    }

    class SubclassOf
    {
        FooIsSubclassOfFoo_Bar_Baz()
        {
            subclassOf := @.subclassOf(new Foo.Bar.Baz(), "Foo")
            YUnit.assert(subclassOf == true, "Found: " subclassOf)
        }

        BarIsSubclassOfFoo_Bar_Baz()
        {
            subclassOf := @.subclassOf(new Foo.Bar.Baz(), "Bar")
            YUnit.assert(subclassOf == true, "Found: " subclassOf)
        }

        BazIsNotSubclassOfFoo_Bar_Baz()
        {
            subclassOf := @.subclassOf(new Foo.Bar.Baz(), "Baz")
            YUnit.assert(subclassOf != true, "Found: " subclassOf)
        }

        PrimitiveReturnsFalse()
        {
            subclassOf := @.subclassOf(1, "Baz")
            YUnit.assert(subclassOf != true, "Found: " subclassOf)
        }
    }

    class InheritsFrom
    {
        GrandChildInheritsFromChild()
        {
            inheritsFrom := @.inheritsFrom(new GrandChild(), "Child")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        GrandChildInheritsFromParent()
        {
            inheritsFrom := @.inheritsFrom(new GrandChild(), "Parent")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        ChildInheritsFromParent()
        {
            inheritsFrom := @.inheritsFrom(new Child(), "Parent")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        ParentDoesNotInheritFromItself()
        {
            inheritsFrom := @.inheritsFrom(new Parent(), "Parent")
            YUnit.assert(inheritsFrom != true, "Found: " inheritsFrom)
        }

        PrimitiveReturnsFalse()
        {
            inheritsFrom := @.inheritsFrom(1, "Parent")
            YUnit.assert(inheritsFrom != true, "Found: " inheritsFrom)
        }
    }
}

class Foo {
    class Bar {
        class Baz {

        }
    }
}

class Parent {
}

class Child extends Parent {
}

class GrandChild extends Child {
}