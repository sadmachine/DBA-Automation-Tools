#Include <Core>

class CoreTests
{
    class TypeOf
    {

        EmptyExplicitArrayIsEmpty()
        {
            typeOf := Core.typeOf(Array())
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyExplicitObjectIsEmpty()
        {
            typeOf := Core.typeOf(Object())
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyImplicitArrayIsEmpty()
        {
            typeOf := Core.typeOf([])
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyImplicitObjectIsEmpty()
        {
            typeOf := Core.typeOf({})
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        ImplicitArrayIsArray()
        {
            typeOf := Core.typeOf(["A", "B", "C"])
            YUnit.assert(typeOf == "Array", "Found: " typeOf)

        }

        ObjectWithNumericKeysIsArray()
        {
            typeOf := Core.typeOf({1: "A", 2: "B", 3: "C"})
            YUnit.assert(typeOf == "Array", "Found: " typeOf)
        }

        ObjectWithStringNumericKeysIsArray()
        {
            typeOf := Core.typeOf({1: "A", 2: "B", 3: "C"})
            YUnit.assert(typeOf == "Array", "Found: " typeOf)
        }

        ObjectWithStringKeysIsObject()
        {
            typeOf := Core.typeOf({a: "A", b: "B", c: "C"})
            YUnit.assert(typeOf == "Object", "Found: " typeOf)
        }

        ObjectWithMixedTypeKeysIsObject()
        {
            typeOf := Core.typeOf({a: "A", 1: "B", 3: "C"})
            YUnit.assert(typeOf == "Object", "Found: " typeOf)
        }

        ObjectWith__ClassKeyIsClassName()
        {
            typeOf := Core.typeOf({__Class: "ClassName", a: "A", 1: "B", 3: "C"})
            YUnit.assert(typeOf == "ClassName", "Found: " typeOf)
        }

        ClassIsFullyQualifiedClassName()
        {
            typeOf := Core.typeOf(Core.RequiredFieldException())
            YUnit.assert(typeOf == "Core.RequiredFieldException", "Found: " typeOf)
        }

        SingleDigitIsDigit()
        {
            typeOf := Core.typeOf(1)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)

            typeOf := Core.typeOf(0)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)
        }

        MultipleDigitIsDigit()
        {
            typeOf := Core.typeOf(123)
            YUnit.assert(typeOf == "Digit", "Found: " typeOf)
        }

        FloatIsFloat()
        {
            typeOf := Core.typeOf(1.23)
            YUnit.assert(typeOf == "Float", "Found: " typeOf)
        }

        NegativeFloatIsFloat()
        {
            typeOf := Core.typeOf(-1.23)
            YUnit.assert(typeOf == "Float", "Found: " typeOf)
        }

        HexadecimalIsHexadecimal()
        {
            typeOf := Core.typeOf(0x0AEF)
            YUnit.assert(typeOf == "Hexadecimal", "Found: " typeOf)
        }

        NegativeSingleDigitIsInteger()
        {
            typeOf := Core.typeOf(-1)
            YUnit.assert(typeOf == "Integer", "Found: " typeOf)
        }

        NegativeMultiDigitIsInteger()
        {
            typeOf := Core.typeOf(-1234)
            YUnit.assert(typeOf == "Integer", "Found: " typeOf)
        }

        StringWithSpaceCharactersIsEmpty()
        {
            typeOf := Core.typeOf(" `n`t")
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        EmptyStringIsEmpty()
        {
            typeOf := Core.typeOf(" `n`t")
            YUnit.assert(typeOf == "Empty", "Found: " typeOf)
        }

        StringIsString()
        {
            typeOf := Core.typeOf("String 123 yup 1.234")
            YUnit.assert(typeOf == "String", "Found: " typeOf)
        }
    }

    class SubclassOf
    {
        FooIsSubclassOfFoo_Bar_Baz()
        {
            subclassOf := Core.subclassOf(Foo.Bar.Baz(), "Foo")
            YUnit.assert(subclassOf == true, "Found: " subclassOf)
        }

        BarIsSubclassOfFoo_Bar_Baz()
        {
            subclassOf := Core.subclassOf(Foo.Bar.Baz(), "Bar")
            YUnit.assert(subclassOf == true, "Found: " subclassOf)
        }

        BazIsNotSubclassOfFoo_Bar_Baz()
        {
            subclassOf := Core.subclassOf(Foo.Bar.Baz(), "Baz")
            YUnit.assert(subclassOf != true, "Found: " subclassOf)
        }

        PrimitiveReturnsFalse()
        {
            subclassOf := Core.subclassOf(1, "Baz")
            YUnit.assert(subclassOf != true, "Found: " subclassOf)
        }
    }

    class InheritsFrom
    {
        GrandChildInheritsFromChild()
        {
            inheritsFrom := Core.inheritsFrom(GrandChild(), "Child")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        GrandChildInheritsFromParent()
        {
            inheritsFrom := Core.inheritsFrom(GrandChild(), "Parent")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        ChildInheritsFromParent()
        {
            inheritsFrom := Core.inheritsFrom(Child(), "Parent")
            YUnit.assert(inheritsFrom == true, "Found: " inheritsFrom)
        }

        ParentDoesNotInheritFromItself()
        {
            inheritsFrom := Core.inheritsFrom(Parent(), "Parent")
            YUnit.assert(inheritsFrom != true, "Found: " inheritsFrom)
        }

        PrimitiveReturnsFalse()
        {
            inheritsFrom := Core.inheritsFrom(1, "Parent")
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