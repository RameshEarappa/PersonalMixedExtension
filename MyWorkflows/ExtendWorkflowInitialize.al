codeunit 50113 InitialiseAllCodeunit
{
    trigger OnRun()
    begin
        CompanyInitialize.Run();
        WorkflowSetup.InitWorkflow();
    end;


    var
        CompanyInitialize: Codeunit "Company-Initialize";
        WorkflowSetup: Codeunit "Workflow Setup";
}