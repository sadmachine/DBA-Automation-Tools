class OrderedInputs
{
    input_descriptors := []

    __New(input_descriptors := [])
    {
        this.input_descriptors := input_descriptors
    }

    getInput()
    {
        for n, input_descriptor in this.input_descriptors
        {
            InputBox, output, 
        }
    }  
}