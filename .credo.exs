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
      color: true
    }
  ]
}
