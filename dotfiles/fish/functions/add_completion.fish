function add_completion --description 'Add completion from official repo' --argument-names name
  set url "https://raw.githubusercontent.com/fish-shell/fish-shell/master/share/completions/$name.fish"
  set output_file ~/.config/fish/completions/$name.fish

  if test -e $output_file
    echo "Warning: $output_file already exists."
    read -P "Overwrite? (y/n): " overwrite
    if not string match -q "y" $overwrite
      echo "Completion download cancelled."
      return
    end
  end

  curl -s -o /dev/null -w "%{http_code}" $url | read -f status_code

  if test $status_code -eq 200
    curl -s -o $output_file $url
    echo "Completion for $name added successfully."
  else
    echo "Error: Failed to download completion for $name. Status code: $status_code"
  end
end
