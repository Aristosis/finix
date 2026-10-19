{
  fuzzel-wrapped,
  coreutils,
  wtype,
  writeShellApplication,
}:
writeShellApplication {
  name = "fuzzel-character-picker";
  runtimeInputs = [
    fuzzel-wrapped
    coreutils
    wtype
  ];
  text = ''
    case "''${1:-}" in
      emoji)
        characters=${./emojis}
        ;;
      unicode)
        characters=${./unicode-characters}
        ;;
      nerd-icons)
        characters=${./nf-icons}
        ;;
      *)
        echo "usage: fuzzel-emojis {emoji|unicode|nerd-icons}" >&2
        exit 1
        ;;
    esac

    selected=$(cat "$characters" | fuzzel -d -l 20)

    if [ -n "$selected" ]; then
      wtype "$(echo "$selected" | cut -d ' ' -f1)"
    fi
  '';
}
