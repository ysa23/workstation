POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--scope)
      SCOPE="$2"
      shift # past argument
      shift # past value
      ;;
    -l|--login)
          LOGIN="true"
          shift # past argument
          ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

usage (){
  echo "Usage: ./claude.sh -s|--scope <SCOPE OF CLAUDE ACCOUNT>"
  echo "Usage: create an alias for a separated claude subscription"
}

if [ -z "${SCOPE}" ]; then
  usage
  exit 1
fi

CLAUDE_DIR=~/.claude-${SCOPE}

if [[ "${LOGIN}" == "true" ]]; then
  CLAUDE_CONFIG_DIR=${CLAUDE_DIR} claude login
fi

CLAUDE_COMMAND="claude-${SCOPE}"

echo "alias ${CLAUDE_COMMAND}='CLAUDE_CONFIG_DIR=${CLAUDE_DIR} claude'" >> ~/.zshrc

echo "claude has completed setup. Restart terminal and run '${CLAUDE_COMMAND}' to start"
