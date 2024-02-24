return {
	"githubname/githubrepo",
	{
		"githubname/githubrepo"

		-- only for cpp files
		ft = "cpp"

		-- what to run after plugin is loaded
		config = function()
			require("plugin").setup()
		end,
	},
}
