{
  autoCmd = [
    {
      event = "InsertEnter";
      command = "norm zz";
    }
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }
  ];
}
