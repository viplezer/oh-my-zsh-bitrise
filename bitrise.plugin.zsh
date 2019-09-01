root_url="https://app.bitrise.io"
api_url="https://api.bitrise.io/v0.1/apps"

function bitrise_open() {
    emulate -L zsh

    bitrise_appid=$(_read_bitrise_appid)
    if [ -z "$bitrise_appid" ]; then
        open_command "$(_bitrise_url)"
        return 0
    fi

    if [[ -n "$1" ]]; then
        open_command "$(_bitrise_url $bitrise_appid $1)"
    else
        open_command "$(_bitrise_url)"
    fi
}

function bitrise_start() {
    emulate -L zsh
    
    bitrise_token=$(_read_bitrise_token)
    if [ -z "$bitrise_token" ]; then
        echo "Bitrise token is needed to use this feature!"
        return 1
    fi

    bitrise_appid=$(_read_bitrise_appid)
    if [ -z "$bitrise_appid" ]; then
        echo "Bitrise app id is needed to use this feature!"
        return 1
    fi
    _bitrise_build_start $bitrise_token $bitrise_appid $1
}

function bitrise_abort() {
    emulate -L zsh
    
    bitrise_token=$(_read_bitrise_token)
    if [ -z "$bitrise_token" ]; then
        echo "Bitrise token is needed to use this feature!"
        return 1
    fi

    bitrise_appid=$(_read_bitrise_appid)
    if [ -z "$bitrise_appid" ]; then
        echo "Bitrise app id is needed to use this feature!"
        return 1
    fi

    if [ -z "$1" ]; then
        echo "App slug is needed to abord a build!"
        return 1
    fi

    _bitrise_build_abort $bitrise_token $bitrise_appid $1
}

function _read_bitrise_appid() {
    local bitrise_appid
    if [[ -f .bitrise_appid ]]; then
        bitrise_appid=$(cat .bitrise_appid)
    elif [[ -f ~/.bitrise_appid ]]; then
        bitrise_appid=$(cat ~/.bitrise_appid)
    elif [[ -n "${BITRISE_APPID}" ]]; then
        bitrise_appid=${BITRISE_APPID}
    fi  
    echo $bitrise_appid
}

function _read_bitrise_token() {
    if [[ -f .bitrise-token ]]; then
        bitrise_token=$(cat .bitrise-token)
    elif [[ -f ~/.bitrise-token ]]; then
        bitrise_token=$(cat ~/.bitrise-token)
    elif [[ -n "${BITRISE_TOKEN}" ]]; then
        bitrise_token=${BITRISE_TOKEN}
    fi
    echo $bitrise_token
}

function _bitrise_url() {
    if [[ $2 == "settings" ]]; then
        echo "$root_url/app/$1#/settings"
    elif [[ $2 == "workflows" ]]; then
        echo "$root_url/app/$1/workflow_editor#!/workflows"
    elif [[ $2 == "builds" ]]; then
        echo "$root_url/app/$1#/builds"
    elif [[ $2 == "add-ons" ]]; then
        echo "$root_url/app/$1#/add-ons"
    elif [[ $2 == "team" ]]; then
        echo "$root_url/app/$1#/team"
    elif [[ $2 == "code" ]]; then
        echo "$root_url/app/$1#/code"
    else
        echo $root_url
    fi
}

function _bitrise_build_start() {
    result=$(curl -s -X POST -H "Authorization: $1" "$api_url/$2/builds" -d '{"hook_info":{"type":"bitrise"},"build_params":{"branch":"develop", "workflow_id": "'"$3"'" }}')
    start_status=$(echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['status'])")
    if [[ $start_status == "ok" ]]; then
        message=$(echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['message'])")
        build_url=$(echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['build_url'])")
        echo "$start_status - $message - $build_url"
    elif [[ $start_status == "error" ]]; then
        message=$(echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['message'])")
        echo "ERROR: $message"
    else
        error=$(echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['error'])")
        echo "ERROR: $error"
    fi
}

function _bitrise_build_abort() {
    result=$(curl -s -X POST -H "Authorization: $1" "$api_url/$2/builds/$3/abort" -d '{}')
    echo $result
}