<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<center><h2>Retail Management System</h2><br><br></center>
		<center><div style="max-width:700px; " class="alert alert-danger" role="alert">
			<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
			This is a test run for DevOps Case Study Login Page...
		</div></center>
	<div class="panel panel-primary center-block" style="max-width:700px">
		<div class="panel-heading">Enter Login Credentials</div>
		<div class="panel-body">
			<form class="form-horizontal" action="/action_page.php">
				<div class="form-group">
					<label class="control-label col-sm-2" for="email">Email:</label>
					<div class="col-sm-10">
						<input type="email" class="form-control" id="email" placeholder="Enter email" name="email">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-sm-2" for="pwd">Password:</label>
					<div class="col-sm-10">          
						<input type="password" class="form-control" id="pwd" placeholder="Enter password" name="pwd">
					</div>
				</div>
				<div class="form-group">        
					<div class="col-sm-offset-2 col-sm-10">
						<div class="checkbox">
							<label>
							<input type="checkbox" name="remember"> Remember me</label>
						</div>
					</div>
				</div>
				<div class="form-group">        
					<div class="col-sm-offset-2 col-sm-10">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	</div>
</body>
