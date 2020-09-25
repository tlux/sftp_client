%{
  configs: [
    %{
      name: "default",
      files: %{
        included: [
          "lib/"
        ],
        excluded: [
          "test/support"
        ]
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
}
