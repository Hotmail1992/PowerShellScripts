# Тестируемая функция


# Блок тестирования Pester
Describe "Тест опроса принтера по умолчанию" {
BeforeAll {
  function Get-DefaultPrinter { 
   [CmdletBinding()]
  param (
    $defaultPrinter
    )
  BEGIN {
    Write-Verbose "Узнаю принтер по умолчанию ... "
  } #BEGIN

  PROCESS {
  $defaultPrinter = Get-CimInstance -ClassName Win32_Printer | Where-Object {$_.Default -eq $true} | Select-Object *
  $defaultPrinter.Name 
  } #PROCESS

  END {
    Write-Verbose "Операция завершена"
  } #END
}
}
}
  Context "Вывод принтера по умолчанию" {
    It "Выводит имя принтера по умолчанию" {
      Mock Get-CimInstance  { 
        return [PSCustomObject]@{ Name = "Mocked-Ricoh" }
      }

      $Result = Get-DefaultPrinter
      $Result | Should -Be "Mocked-Ricoh"
    }
  }
